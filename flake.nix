{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        # pkgs = nixpkgs.legacyPackages.${system};
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        inherit (pkgs) lib;
        nativeBuildInputs = with pkgs; [
          java
          git
        ];
        buildInputs = with pkgs; [
          # GL
          libGL
          glfw3-minecraft

          # audio
          libpulseaudio
          openal

          flite
          jetbrains.idea
        ];
        java = pkgs.jetbrains.jdk-no-jcef;
      in {
        devShells.default = pkgs.mkShell {
          inherit nativeBuildInputs buildInputs;

          env = {
            LD_LIBRARY_PATH = lib.makeLibraryPath buildInputs;
            JAVA_HOME = java.home;
          };
        };
      }
    );
}
