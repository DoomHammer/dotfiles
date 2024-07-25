{ config, flakePath, pkgs, ... }:

let
  flakePath = config: "${config.home.homeDirectory}/.config/nix";
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/features/neovim";
in
{
  home.packages = with pkgs; [
    neovim
    neovide

    fd
    git
    lazygit
    ripgrep
  ];
  xdg.configFile = {
    "nvim/init.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/neovim-config/nvim/init.lua";
    "nvim/lazyvim.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/neovim-config/nvim/lazyvim.json";
    "nvim/lazy-lock.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/neovim-config/nvim/lazy-lock.json";
    "nvim/lua".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/neovim-config/nvim/lua";
  };
}
