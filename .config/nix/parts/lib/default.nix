{ inputs, ... }:
let
  lib0 = inputs.nixpkgs.lib;

  gardenLib = lib0.makeExtensible (
    self:
    let
      lib = self;
    in
    {
      helpers = import ./helpers.nix { inherit lib; };

      # we have to re-export the functions we want to use, but don't want to refer to the whole lib
      # "path". e.g. lib.hardware.isx86Linux can be shortened to lib.isx86Linux
      # NOTE: never re-export templates
      inherit (self.helpers) mkDarwin mkNixos;
    }
  );

  # we need to extend gardenLib with the nixpkgs lib to get the full set of functions
  # if we do it the otherway around we will get errors saying mkMerge and so on don't exist
  finalLib = gardenLib.extend (_: _: lib0);
in
{
  flake.lib = finalLib;
  perSystem._module.args.lib = finalLib;
}
