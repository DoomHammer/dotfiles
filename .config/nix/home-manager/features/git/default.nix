{ config, flakePath, pkgs, ... }:

let
  flakePath = config: "${config.home.homeDirectory}/.config/nix";
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/features/git";
in
{
  home.packages = with pkgs; [
    diff-so-fancy
    difftastic
    git
    git-lfs
    lazygit
  ];
  programs.git-cliff.enable = true;
# Migrate gitconfig to https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.enable
}
