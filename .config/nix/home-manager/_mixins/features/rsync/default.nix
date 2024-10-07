{ pkgs, ... }:

{
  home.packages = with pkgs; [ rsync ];
}
