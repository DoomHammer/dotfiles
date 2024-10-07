# Stolen from https://github.com/wimpysworld/nix-config/blob/020060f9aaa5bd46eecd8316a5cd76bdda0b72d4/lib/default.nix
{
  inputs,
  outputs,
  stateVersion,
  ...
}:
let
  helpers = import ./helpers.nix { inherit inputs outputs stateVersion; };
in
{
  inherit (helpers)
    mkDarwin
    mkHome
    mkNixos
    forAllSystems
    ;
}
