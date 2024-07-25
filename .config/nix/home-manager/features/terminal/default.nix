{ config, flakePath, pkgs, ... }:

let
  flakePath = config: "${config.home.homeDirectory}/.config/nix";
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/features/terminal";
in
{
  home.packages = with pkgs; [
    alacritty
    wezterm
  ];
  # Migrate ~/.config/alacritty/alacritty.yml to programs.alacritty.settings
  xdg.configFile."alacritty/alacritty.yml".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/alacritty-config/alacritty.yml";
# programs.wezterm = {
#     enable = true;
#     enableBashIntegration = true;
#     enableZshIntegration = true;
#     programs.wezterm.colorSchemes = {};
#   }
}
