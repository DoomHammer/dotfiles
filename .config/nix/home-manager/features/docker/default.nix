{ config, flakePath, pkgs, ... }:

let
  flakePath = config: "${config.home.homeDirectory}/.config/nix";
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/features/docker";
in
{
  home.packages = with pkgs; [
    colima
    docker
  ];
  home.file.".colima/default/colima.yaml".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/colima-config/default/colima.yaml";
  programs.ssh.extraConfig = ''
      Include /Users/doomhammer/.colima/ssh_config
    '';
}
