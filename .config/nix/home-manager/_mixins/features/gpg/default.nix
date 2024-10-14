{ pkgs, ... }:

{
  home.packages = with pkgs; [ gnupg ];
  # This: https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.enable
}
