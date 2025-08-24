{ pkgs, ... }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    qemu
    qemu_xen
    qemu-utils
    grub2_pvgrub_image
    xen
    iproute2
    gawk
  ];

  shellHook = ''
    BRIDGE="xenbr_alpine"
    IFACE=$(ip route | grep default | awk '{print $5}')
    NETWORK="192.168.10.0"
    IP="192.168.10.1"

    cleanup() {
      sudo xl destroy alpine
      sudo iptables -D FORWARD -i "$BRIDGE" -o "$IFACE" -j ACCEPT
      sudo iptables -D FORWARD -i "$IFACE" -o "$BRIDGE" -m state --state RELATED,ESTABLISHED -j ACCEPT
      sudo iptables -t nat -D POSTROUTING -s "$NETWORK"/24 -o "$IFACE" -j MASQUERADE
      sudo ip link set "$BRIDGE" down
      sudo ip link delete "$BRIDGE"
    }

    trap cleanup EXIT

    sudo ip link add "$BRIDGE" type bridge
    sudo ip link set "$BRIDGE" up
    sudo ip addr add "$IP"/24 dev "$BRIDGE"
    sudo iptables -t nat -A POSTROUTING -s "$NETWORK"/24 -o "$IFACE" -j MASQUERADE
    sudo iptables -A FORWARD -i "$IFACE" -o "$BRIDGE" -m state --state RELATED,ESTABLISHED -j ACCEPT
    sudo iptables -A FORWARD -i "$BRIDGE" -o "$IFACE" -j ACCEPT

    cat > ./vm/alpine/vm.cfg << EOF
    name='alpine'
    memory='2048'
    vcpus=2
    type='pv'
    kernel='${pkgs.grub2_pvgrub_image}/lib/grub-xen/grub-x86_64-xen.bin'
    disk=[ './vm/alpine/disk.qcow2,qcow2,hda,w' ]
    boot='d'
    vif = [ 'mac=00:16:3e:00:00:00,bridge=$BRIDGE' ]
    device_model_override='/run/current-system/sw/bin/qemu-system-i386'
    EOF

    sudo xl create ./vm/alpine/vm.cfg -c
  '';
}
