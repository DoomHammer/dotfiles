{ config, flakePath, pkgs, ... }:

{
  home.packages = with pkgs; [
    navi
  ];

  # home.activation = {
  #   myActivationAction = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #     run ${pkgs.navi}/bin/navi repo add denisidoro/cheats $VERBOSE_ARG
  #   '';
  # };

  programs.navi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
# navi repo add denisidoro/cheats
# navi repo add denisidoro/navi-tldr-pages
# navi repo add papanito/cheats
# navi repo add tsologub/navi-cheats
# navi repo add kbknapp/navi-cheats

}
