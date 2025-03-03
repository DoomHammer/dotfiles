{
  config,
  flakePath,
  pkgs,
  ...
}:

let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/_mixins/features/shell";
in
{
  home.packages = with pkgs; [
    fzf
    shellcheck
    starship
  ];
  # targets.genericLinux.enable = true;
  # TODO: Migrate ~/.shell-aliases to home.shellAliases
  programs = {
    dircolors.enable = true;
    fzf = {
      # CTRL-T to open file widget
      # ALT-C to open change dir widget
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      changeDirWidgetCommand = "fd --type d";
      # TODO: For some reason this doesn't work. Why?
      # colors = {
      #   "fg" = "-1";
      #   "bg" = "-1";
      #   "hl" = "#268bd2";
      #   "fg+" = "#eee8d5";
      #   "bg+" = "#073642";
      #   "hl+" = "#268bd2";
      #   # "header" = "#586e75";
      #   "info" = "#b58900";
      #   "prompt" = "#b58900";
      #   "pointer" = "#fdf6e3";
      #   "marker" = "#fdf6e3";
      #   "spinner" = "#b58900";
      # };
      tmux.enableShellIntegration = true;
    };
    skim = {
      defaultOptions = [
        "--color fg:240,bg:230,hl:33,fg+:241,bg+:221,hl+:33"
        "--color info:33,prompt:33,pointer:166,marker:166,spinner:33"
      ];
    };
    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      # Port settings to https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.settings
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      # Replace cd with z and add cdi to access zi
      options = [ "--cmd cd" ];
    };
  };
  xdg.configFile."starship.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/starship-config/starship.toml";
  home.file = {
    ".shell-aliases".source = config.lib.file.mkOutOfStoreSymlink "${dir}/shell-config/shell-aliases";
    ".shell-common".source = config.lib.file.mkOutOfStoreSymlink "${dir}/shell-config/shell-common";
    ".shell-env".source = config.lib.file.mkOutOfStoreSymlink "${dir}/shell-config/shell-env";
    ".shell-logout".source = config.lib.file.mkOutOfStoreSymlink "${dir}/shell-config/shell-logout";
  };
}
