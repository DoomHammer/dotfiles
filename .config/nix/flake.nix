{
  # Potential inspiration:
  # - https://github.com/jwiegley/nix-config/blob/master/flake.nix
  # - https://github.com/MatthiasBenaets/nix-config/blob/master/README.org
  # - https://github.com/Misterio77/nix-starter-configs/blob/main/minimal/flake.nix
  # - https://github.com/gvolpe/nix-config/blob/3e27ad72fe6e3c9dbb85eb29854dc4dc29274ab9/flake.nix
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.inputs.systems.follows = "systems";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Prebuilt package index - provides comma package
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # we can use this to provide overridable systems
    systems = {
      type = "github";
      owner = "nix-systems";
      repo = "default";
    };

    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # this adds pre commit hooks via nix to our repo
    git-hooks = {
      type = "github";
      owner = "cachix";
      repo = "git-hooks.nix";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
      };
    };

    flake-checker = {
      type = "github";
      owner = "DeterminateSystems";
      repo = "flake-checker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # a tree-wide formatter
    treefmt-nix = {
      type = "github";
      owner = "numtide";
      repo = "treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      inherit (self) outputs;
      stateVersion = "24.05";
      helper = import ./parts/lib/helpers.nix { inherit inputs outputs stateVersion; };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      flake = {
        # home-manager switch -b backup --flake $HOME/.config/nix
        # nix run nixpkgs#home-manager -- switch -b backup --flake "${HOME}/.config/nix"
        homeConfigurations = {
          "doomhammer@Piotrs-MacBook-Air" = helper.mkHome {
            hostname = "Piotrs-MacBook-Air";
            platform = "aarch64-darwin";
            desktop = "aqua";
          };
          "doomhammer@helios" = helper.mkHome {
            hostname = "helios";
            platform = "aarch64-darwin";
            desktop = "aqua";
          };
          "doomhammer@eos" = helper.mkHome {
            hostname = "eos";
            platform = "aarch64-darwin";
            desktop = "aqua";
          };
        };
        #nix run nix-darwin -- switch --flake ~/.config/nix
        #nix build .#darwinConfigurations.{hostname}.config.system.build.toplevel
        darwinConfigurations = {
          "Piotrs-MacBook-Air" = helper.mkDarwin { hostname = "Piotrs-MacBook-Air"; };
          "helios" = helper.mkDarwin { hostname = "helios"; };
          "eos" = helper.mkDarwin { hostname = "eos"; };
        };
        # Custom packages and modifications, exported as overlays
        overlays = import ./parts/overlays { inherit inputs; };
        # Custom packages; accessible via 'nix build', 'nix shell', etc
        packages = helper.forAllSystems (system: import ./parts/pkgs nixpkgs.legacyPackages.${system});
      };

      imports = [ ./parts ];
    };
}
