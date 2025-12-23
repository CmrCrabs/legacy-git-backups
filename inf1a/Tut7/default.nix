{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = with pkgs.haskellPackages; [
    # ghcup
    ghc
    cabal-install
  ];
}
