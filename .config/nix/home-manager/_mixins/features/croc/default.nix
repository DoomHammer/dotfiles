{ pkgs, ... }:

{
  home.packages = with pkgs; [ croc ];
}
