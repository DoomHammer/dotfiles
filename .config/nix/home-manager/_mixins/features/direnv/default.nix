{ pkgs, ... }:

{
  home.packages = with pkgs; [ direnv ];
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
