{ pkgs, ... }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    iproute2
    gawk
  ];

  shellHook = ''
    BRIDGE="xenbr"
    IFACE=$(ip route | grep default | awk '{print $5}' | head -n 1)
    NETWORK="10.0.0.0"
    IP="10.0.0.1"

    cleanup() {
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
  '';
}
