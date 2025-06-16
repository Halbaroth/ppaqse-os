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
          fontconfig
        ];

        shellHook =
        let
          fontsConf = pkgs.makeFontsConf {
            fontDirectories = [ "${pkgs.fira-sans}/share/fonts/opentype" ];
          };
        in
        ''
          export FONTCONFIG_FILE="${fontsConf}"
        '';
      };
    });
  };
}
