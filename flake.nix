{
  outputs = { nixpkgs, ... }: let
    forAllSystems = fn:
      nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ] (system: fn system);
  in {
    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          typst
          gnumake
          fira-sans
          fira-mono
          fira-code
          fontconfig
          netcat
        ];

        shellHook =
        let
          fontsConf = pkgs.makeFontsConf {
            fontDirectories = [
              "${pkgs.fira-sans}/share/fonts/opentype"
              "${pkgs.fira-mono}/share/fonts/opentype"
              "${pkgs.fira-code}/share/fonts/truetype"
            ];
          };
        in
        ''
          export FONTCONFIG_FILE="${fontsConf}"
        '';
      };

      network = pkgs.callPackage ./vm/network.nix { inherit pkgs; };
      alpine-setup = pkgs.callPackage ./vm/alpine/setup.nix { inherit pkgs; };
      alpine = pkgs.callPackage ./vm/alpine/default.nix { inherit pkgs; };
      mirageos = pkgs.callPackage ./vm/mirageos/default.nix { inherit pkgs; };
    });
  };
}
