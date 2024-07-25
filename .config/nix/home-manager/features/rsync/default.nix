{ config, flakePath, pkgs, ... }:

{
  home.packages = with pkgs; [
    rsync
  ];
}
