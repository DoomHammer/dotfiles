{ config, flakePath, pkgs, ... }:
let
  flakePath = config: "${config.home.homeDirectory}/.config/nix";
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/features/bash";
in
{
  home.packages = with pkgs; [
    bashInteractive
  ];
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      . $HOME/.bashrc.prev
    '';
  };
  home.file = {
    ".bash_logout".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/bash-config/bash_logout";
    ".bashrc.prev".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/bash-config/bashrc";
  };
}
