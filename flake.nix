{
  inputs = {
    systems.url = "github:nix-systems/default-linux";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    inputs:
    let
      eachSystem = inputs.nixpkgs.lib.genAttrs (import inputs.systems);
      pkgsFor = eachSystem (system: inputs.nixpkgs.legacyPackages.${system});
    in
    rec {
      devShells = eachSystem (system: {
        default = pkgsFor.${system}.mkShell {
          LD_LIBRARY_PATH = "${inputs.nixpkgs.lib.makeLibraryPath [ pkgsFor.${system}.libGL ]}";
          FONT_PATH = ./assets/NotoSans.ttf;
          EMOJI_PATH = ./assets/noto-untouchedsvg.ttf;
          packages = [
            packages.${system}.hypr-donate-pls
          ];
          nativeBuildInputs = with pkgsFor.${system}; [
            meson
            ninja
            pkg-config
            cmake
          ];
          buildInputs = with pkgsFor.${system}; [
            glfw
            freetype
            packages.${system}.imgui-hypr
          ];
        };
      });

      packages = eachSystem (system: rec {
        default = hypr-donate-pls;
        plutovg = pkgsFor.${system}.callPackage ./nix/plutovg.nix { };
        plutosvg = pkgsFor.${system}.callPackage ./nix/plutosvg.nix { inherit plutovg; };
        imgui-hypr = pkgsFor.${system}.callPackage ./nix/imgui-hypr.nix { inherit plutovg plutosvg; };
        hypr-donate-pls = pkgsFor.${system}.callPackage ./nix/default.nix { inherit imgui-hypr; };
      });
    };
}
