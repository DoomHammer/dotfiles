{ config, flakePath, pkgs, ... }:
{
  home.packages = with pkgs; [
    atuin
    bash-preexec
    blesh
  ];
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      inline_height = 20;
    };
  };
}
