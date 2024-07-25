{ config, flakePath, pkgs, ... }:
{
  home.packages = with pkgs; [
    asciinema
  ];
}
