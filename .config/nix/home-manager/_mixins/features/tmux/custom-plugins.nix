{ lib, pkgs, ... }:

let
  buildTmuxPlugin = pkgs.tmuxPlugins.mkTmuxPlugin;
in
{
  gitmux = buildTmuxPlugin {
    pluginName = "gitmux";
    version = "v0.11.2";
    src = lib.fetchTarball {
      url = "https://github.com/arl/gitmux/archive/refs/tags/v0.11.2.tar.gz";
      sha256 = "0l97cqbnq31f769jak31ffb7bkf8rrg72w3vd0g3fjpq0717864b";
    };
  };
}
