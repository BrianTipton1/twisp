{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    inputs.utils.lib.eachSystem [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ] (system:
      let
        name = "twisp";
        pkgs = import nixpkgs { inherit system; };
      in rec {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            haskellPackages.parsec
            cabal-install
            haskell-language-server
          ];
        };
        packages.default = pkgs.haskellPackages.developPackage { root = ./.; };
        packages."${name}" = packages.default;
      });
}
