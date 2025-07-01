{
  system ? builtins.currentSystem,
}:

let
  flake = builtins.getFlake (toString ../../.);
  inherit (flake.inputs.nixpkgs) lib;

  homeManagerConfigsForSystem = lib.attrByPath [ system ] { } flake.homeConfigurations;
in
# Return all home-manager configuration derivations matching the current system
lib.attrsets.mapAttrs (_: hmConfig: hmConfig.activationPackage) homeManagerConfigsForSystem
