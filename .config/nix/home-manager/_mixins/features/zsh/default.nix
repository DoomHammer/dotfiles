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
  dir = "${flakePath config}/home-manager/_mixins/features/zsh";
in
{
  home.packages = with pkgs; [
    fzf
    nix-zsh-completions
    zplug
    zsh
  ];
  # Read more: https://home-manager-options.extranix.com/?query=zsh&release=master
  programs.zsh = {
    enable = true;
    enableCompletion = false; # Cause autocomplete
    enableVteIntegration = true;
    zplug = {
      enable = true;
    };
    initExtraFirst = ''
      # Via https://tanguy.ortolo.eu/blog/article25/shrc
      #
      # Zsh always executes zshenv. Then, depending on the case:
      # - run as a login shell, it executes zprofile;
      # - run as an interactive, it executes zshrc;
      # - run as a login shell, it executes zlogin.
      #
      # At the end of a login session, it executes zlogout, but in reverse order, the
      # user-specific file first, then the system-wide one, constituting a chiasmus
      # with the zlogin files.

      skip_global_compinit=1

      # Thanks to https://github.com/elifarley/shellbase/blob/master/.zshrc
      test -r ~/.shell-env && source ~/.shell-env

      # WSL cannot handle `nice`
      if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null ; then
        unsetopt BG_NICE
      fi
    '';
    initExtra = ''
      . $HOME/.zshrc.prev
    '';
    autocd = true;
    # autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      tree = "${pkgs.eza}/bin/eza --tree";
    };
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.autocd
  };
  home.file = {
    ".zlogout".source = config.lib.file.mkOutOfStoreSymlink "${dir}/zsh-config/zlogout";
    ".zshrc.prev".source = config.lib.file.mkOutOfStoreSymlink "${dir}/zsh-config/zshrc";
  };
}
