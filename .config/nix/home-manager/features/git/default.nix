{ config, flakePath, pkgs, ... }:

let
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
  # TODO: Migrate gitconfig to https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.enable
  home.file = {
    ".gitconfig".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/git-config/gitconfig";
    ".gitignore_global".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/git-config/gitignore_global";
    ".gitmessage".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/git-config/gitmessage";
  };
}
