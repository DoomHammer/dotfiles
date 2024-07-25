{ config, flakePath, pkgs, ... }:
{
  home.packages = with pkgs; [
    yazi
  ];

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
