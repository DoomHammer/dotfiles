{ pkgs, ... }:

{
  home.packages = with pkgs; [ go ];
  programs.go.enable = true;
}
