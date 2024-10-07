{ pkgs, ... }:

{
  home.packages = with pkgs; [ lldb ];
}
