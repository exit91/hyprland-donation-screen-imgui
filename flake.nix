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
    {
      devShells = eachSystem (system: {
        default = pkgsFor.${system}.mkShell {
          nativeBuildInputs = with pkgsFor.${system}; [
            meson
            ninja
            pkg-config
            cmake
          ];
          buildInputs = with pkgsFor.${system}; [
            glfw
            freetype
            libGL
            imgui
          ];
        };
      });
    };
}
