{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cppcheck
    gcc
  ];
}
