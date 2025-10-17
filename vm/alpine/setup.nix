{ pkgs, ... }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    qemu
    qemu_xen
    qemu-utils
    xen
    p7zip
  ];

  shellHook = ''
    set -e
    BRIDGE="xenbr"
    ISO="./vm/alpine/alpine-standard-3.22.1-x86_64.iso"

    cleanup() {
      sudo xl destroy 'alpine_setup'
    }

    trap cleanup EXIT

    7z x -aoa "$ISO" boot/vmlinuz-lts -o./vm/alpine/
    7z x -aoa "$ISO" boot/initramfs-lts -o./vm/alpine/

    cat > ./vm/alpine/setup.cfg << EOF
    name='alpine_setup'
    memory='2048'
    vcpus=2
    type='pv'
    kernel='./vm/alpine/boot/vmlinuz-lts'
    ramdisk='./vm/alpine/boot/initramfs-lts'
    disk=[
      'file:$ISO,hdc:cdrom,r',
      './vm/alpine/disk.qcow2,qcow2,hda,w'
    ]
    boot='c'
    vif = [ 'mac=00:16:3e:00:00:00,bridge=$BRIDGE' ]
    device_model_override='/run/current-system/sw/bin/qemu-system-i386'
    EOF

    sudo xl create ./vm/alpine/setup.cfg -c
  '';
}
