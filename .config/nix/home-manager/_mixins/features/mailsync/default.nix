{ pkgs, ... }:
{
  home.packages = with pkgs; [ vdirsyncer ];
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vdirsyncer.enable
  # Calendar integration:
  # https://nix-community.github.io/home-manager/options.xhtml#opt-accounts.calendar.accounts._name_.vdirsyncer.collections
}
