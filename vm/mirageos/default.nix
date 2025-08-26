{ pkgs, ... }:

let
  ocamlPackages = pkgs.ocaml-ng.ocamlPackages_5_1;
in
pkgs.mkShell {
  packages = (with pkgs; [
    qemu
    qemu_xen
    qemu-utils
    xen
    solo5
  ]) ++ (with ocamlPackages; [
    # findlib
    # ocaml
    # dune_3
    # mirage
    # mirage-xen
    # mirage-logs
    # mirage-profile
    # mirage-runtime
    # shared-memory-ring-lwt
    # lwt
    # duration
    # cstruct
    # fmt
    # io-page
    # logs
    # lwt-dllist
    # xenstore
    # mirage-unix
    # mirage-clock-unix
    # mirage-bootvar-unix
  ]);

  # shellHook = ''
  #   BRIDGE="xenbr"

  #   cleanup() {
  #     sudo xl destroy mirageos
  #   }

  #   trap cleanup EXIT

  #   cat > ./vm/mirageos/vm.cfg << EOF
  #   name='mirageos'
  #   memory='2048'
  #   vcpus=2
  #   type='pv'
  #   kernel='${pkgs.grub2_pvgrub_image}/lib/grub-xen/grub-x86_64-xen.bin'
  #   disk=[ './vm/alpine/disk.qcow2,qcow2,xvda,w' ]
  #   boot='d'
  #   vif = [ 'mac=00:16:3e:00:00:00,bridge=$BRIDGE' ]
  #   device_model_override='/run/current-system/sw/bin/qemu-system-i386'
  #   EOF

  #   sudo xl create ./vm/mirageos/vm.cfg -c
  # '';
}
