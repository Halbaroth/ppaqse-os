{ pkgs, ... }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    qemu
    qemu_xen
    qemu-utils
    grub2_pvgrub_image
    xen
  ];

  shellHook = ''
    BRIDGE="xenbr"

    cleanup() {
      sudo xl destroy alpine
    }

    trap cleanup EXIT

    cat > ./vm/alpine/vm.cfg << EOF
    name='alpine'
    memory='2048'
    vcpus=2
    type='pv'
    kernel='${pkgs.grub2_pvgrub_image}/lib/grub-xen/grub-x86_64-xen.bin'
    disk=[ './vm/alpine/disk.qcow2,qcow2,xvda,w' ]
    boot='d'
    vif = [ 'mac=00:16:3e:00:00:00,bridge=$BRIDGE' ]
    device_model_override='/run/current-system/sw/bin/qemu-system-i386'
    EOF

    sudo xl create ./vm/alpine/vm.cfg -c
  '';
}
