{ config, flakePath, pkgs, ... }:

{
  home.packages = with pkgs; [
    tmate
  ];

  programs.tmate.enable = true;
}
