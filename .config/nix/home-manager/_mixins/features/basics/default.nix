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
  dir = "${flakePath config}/home-manager/_mixins/features/basics";
in
{
  home.packages = with pkgs; [
    btop
    curl
    du-dust
    eza
    fd
    htop
    jq
    just
    lesspipe
    ripgrep
    silver-searcher
    unzip
    wget
    zstd
  ];
  programs = {
    btop = {
      enable = true;
      settings = {
        color_theme = "solarized_light";
        # color_theme = TTY
        # Theme background = true
        # force_TTY = true
      };
    };
    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
      git = true;
      icons = true;
    };
    fd.enable = true;
    htop.enable = true;
    lesspipe.enable = true;
    man.enable = true;
    ripgrep = {
      enable = true;
      arguments = [
        # Don't let ripgrep vomit really long lines to my terminal, and show a preview.
        "--max-columns=150"
        "--max-columns-preview"

        # Search hidden files / directories (e.g. dotfiles) by default
        "--hidden"

        # Using glob patterns to include/exclude files or folders
        "--glob=!.git/*"

        # Set the colors.
        "--colors=line:none"
        "--colors=line:style:bold"

        # Because who cares about case!?
        "--smart-case"
      ];
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
  xdg.configFile."htop/htoprc".source = config.lib.file.mkOutOfStoreSymlink "${dir}/htop-config/htoprc";
  xdg.configFile."btop/themes/solarized_light.theme".source = config.lib.file.mkOutOfStoreSymlink "${dir}/btop-config/btop/themes/solarized_light.theme";
}
