{ pkgs, ... }:

pkgs.mkShell {
  buildInputs = with pkgs; {
    qemu
    qemu_xen
    qemu-utils
    xen
  }

  shellHook = ''
    cat > ./alpine-nix.cfg << EOF
    name='alpine'
    memory='2048'
    vcpus=2
    type='pv'
    kernel=''
    disk=[ './alpine.qcow2,qcow2,hda,w' ]
    boot='d'
    vif = [ 'mac=00:16:3e:00:00:00,bridge=xenbr0' ]
    device_model_override='/run/current-system/sw/bin/qemu-system-i386'
    EOF
  ''
}
