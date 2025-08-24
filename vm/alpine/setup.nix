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
    BRIDGE="xenbr"
    ISO="./vm/alpine/alpine-stardard-3.22.1-x86_64.iso"

    cleanup() {
      sudo xl destroy alpine-setup
    }

    trap cleanup EXIT

    7z e "$ISO"/boot/vmlinuz-lts ./vm/alpine/vmlinuz-lts 
    7z e "$ISO"/boot/initramfs-lts ./vm/alpine/initramfs-lts

    cat > ./vm/alpine/setup.cfg << EOF
    name='alpine-setup'
    memory='2048'
    vcpus=2
    type='pv'
    kernel='./vm/alpine/vmlinuz-lts'
    ramdisk='./vm/alpine/initramfs-lts'
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
