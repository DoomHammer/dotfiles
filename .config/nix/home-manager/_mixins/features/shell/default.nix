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
  # Enable dircolors?
  home.packages = with pkgs; [
    fzf
    shellcheck
    starship
  ];
  # targets.genericLinux.enable = true;
  # Migrate ~/.shell-aliases to home.shellAliases
  programs = {
    fzf = {
      # CTRL-T to open file widget
      # ALT-C to open change dir widget
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      changeDirWidgetCommand = "fd --type d";
      # https://github.com/junegunn/fzf/wiki/Color-schemes#solarized-light
      # colors
      tmux.enableShellIntegration = true;
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
  xdg.configFile."starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${dir}/starship-config/starship.toml";
  home.file = {
    ".shell-aliases".source = config.lib.file.mkOutOfStoreSymlink "${dir}/shell-config/shell-aliases";
    ".shell-common".source = config.lib.file.mkOutOfStoreSymlink "${dir}/shell-config/shell-common";
    ".shell-env".source = config.lib.file.mkOutOfStoreSymlink "${dir}/shell-config/shell-env";
    ".shell-logout".source = config.lib.file.mkOutOfStoreSymlink "${dir}/shell-config/shell-logout";
  };
}
