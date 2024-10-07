{
  description = "DoomHammer's repository of flake templates";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05-small";
    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } { imports = [ ./.config/nix/parts/templates ]; };
}
