{ config, flakePath, pkgs, ... }:

let
  flakePath = config: "${config.home.homeDirectory}/.config/nix";
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/features/basics";
in
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "solarized_light";
      # color_theme = TTY
      # Theme background = true
      # force_TTY = true
    };
  };
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    icons = true;
  };
  home.packages = with pkgs; [
    btop
    curl
    du-dust
    eza
    fd
    htop
    jq
    lesspipe
    ripgrep
    silver-searcher
    unzip
    wget
  ];
  programs.fd.enable = true;
  programs.htop.enable = true;
  programs.lesspipe.enable = true;
  programs.man.enable = true;
  programs.ripgrep.enable = true;
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
  xdg.configFile."htop/htoprc".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/htop-config/htoprc";
  xdg.configFile."btop/themes/solarized_light.theme".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/btop-config/btop/themes/solarized_light.theme";
}
