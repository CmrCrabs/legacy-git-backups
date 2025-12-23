{
  description = "neovimming";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    neovim-nightly,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          neovim-nightly.overlays.default
        ];
      };
			nightly-neovim = neovim-nightly.packages.${system}.default;

      nvimWrap = import ./nvim-package.nix {inherit pkgs self nightly-neovim;};
    in {
      packages.default = nvimWrap;
    })
    // {
      overlays.default = final: prev: {
        neovim = import ./nvim-package.nix {
          pkgs = final;
          self = self;
        };
      };
    };
}
