{
  config,
  flakePath,
  lib,
  pkgs,
  ...
}:

let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/_mixins/features/zsh";
  plugins = pkgs.callPackage ./custom-plugins.nix { };
in
{
  home.packages = with pkgs; [
    fzf
    nix-zsh-completions
    zsh
  ];
  # Read more: https://home-manager-options.extranix.com/?query=zsh&release=master
  programs.zsh = {
    enable = true;
    enableCompletion = false; # Cause autocomplete
    enableVteIntegration = true;
    plugins = [
      {
        # Must be before plugins that wrap widgets, such as zsh-autosuggestions or fast-syntax-highlighting
        name = "zsh-fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
        file = "share/zsh-completions/zsh-completions.zsh";
      }
      {
        name = "zsh-autocomplete";
        src = pkgs.zsh-autocomplete;
        file = "share/zsh-autocomplete/zsh-autocomplete.plugin.zsh";
      }
      {
        name = "zsh-forgit";
        src = pkgs.zsh-forgit;
        file = "share/zsh/zsh-forgit/forgit.plugin.zsh";
      }
      {
        name = "zsh-you-should-use";
        src = pkgs.zsh-you-should-use;
        file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      }
      {
        name = "zsh-nix-shell";
        src = pkgs.zsh-nix-shell;
        file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
      }
      {
        name = "zsh-sensible";
        src = plugins.zsh-sensible;
        file = "share/zsh-sensible/zsh-sensible.plugin.zsh";
      }
    ];
    initContent = lib.mkMerge [
      (lib.mkBefore ''
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
      '')
      (lib.mkAfter ''
        . $HOME/.zshrc.prev

          export NIX_BUILD_SHELL=${pkgs.zsh}/bin/zsh
      '')
    ];
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
