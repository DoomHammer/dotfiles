{
  # Potential inspiration:
  # - https://github.com/jwiegley/nix-config/blob/master/flake.nix
  # - https://github.com/MatthiasBenaets/nix-config/blob/master/README.org
  # - https://github.com/Misterio77/nix-starter-configs/blob/main/minimal/flake.nix
  # - https://github.com/gvolpe/nix-config/blob/3e27ad72fe6e3c9dbb85eb29854dc4dc29274ab9/flake.nix
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Prebuilt package index - provides comma package
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, lix-module, home-manager, ... }:
  let
    inherit (self) outputs;
    flakePath = config: "${config.home.homeDirectory}/.config/nix/";
  in
  {
    darwinConfigurations."Piotrs-MacBook-Air" = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit flakePath inputs outputs; };
      modules = [
        ./darwin/default.nix
        lix-module.nixosModules.default
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "orig";
          home-manager.users.doomhammer = import ./home-manager/home.nix;
        }
      ];
    };
  };
}
