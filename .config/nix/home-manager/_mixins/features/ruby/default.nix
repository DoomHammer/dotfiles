{ pkgs, ... }:

{
  home.packages = with pkgs; [ ruby ];
}
