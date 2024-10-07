{
  config,
  inputs,
  outputs,
  pkgs,
  stateVersion,
  username,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
in
{
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    ./_mixins/scripts

    ./_mixins/features/basics

    ./_mixins/features/asciinema
    ./_mixins/features/atuin
    ./_mixins/features/bash
    ./_mixins/features/cmake
    ./_mixins/features/cpp
    ./_mixins/features/croc
    ./_mixins/features/direnv
    ./_mixins/features/docker
    ./_mixins/features/git
    ./_mixins/features/gnu
    ./_mixins/features/go
    ./_mixins/features/gpg
    ./_mixins/features/image
    ./_mixins/features/k8s
    ./_mixins/features/lldb
    ./_mixins/features/mosh
    ./_mixins/features/music
    ./_mixins/features/navi
    ./_mixins/features/neovim
    ./_mixins/features/rsync
    ./_mixins/features/ruby
    ./_mixins/features/shell
    ./_mixins/features/terminal
    ./_mixins/features/tmate
    ./_mixins/features/tmux
    ./_mixins/features/video
    ./_mixins/features/vscode
    ./_mixins/features/yazi
    ./_mixins/features/zsh
  ];
  # ] ++ lib.optionals isLinux [
  #   ./features/gdb
  # ];
  home = {
    inherit stateVersion;
    inherit username;
    homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
  };

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.sops
    pkgs.yadm

    # pkgs.cyme
    # pkgs.dogdns
    # pkgs.dua
    # pkgs.duf
    # pkgs.lastpass-cli
    # pkgs.sd
    # pkgs.lurk

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/davish/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
    # MANPAGER = "sh -c 'col --no-backspaces --spaces | bat --language man'";
    # MANROFFOPT = "-c";
    # PAGER = "bat";
    # SYSTEMD_EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.nix-index-database.comma.enable = true;
  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    forwardAgent = true;
  };
}
# TODO:
#
### shell-common
# # Darwin
# export MAKEFLAGS="-j $(sysctl -n hw.ncpu)"
# # Linux
# glibcLocales=$(nix-build --no-out-link "<nixpkgs>" -A glibcLocales)
# export LOCALE_ARCHIVE="${glibcLocales}/lib/locale/locale-archive"
#
### shell-aliases
# alias dos2unix='FIXME'
#
# alias tmux='tmux -2'
#
# if command -v exa >/dev/null 2>&1; then
# 	alias ls='exa'
# else
# 	alias ls='ls --color=auto'
# fi
# alias grep='grep --color=auto'
# alias fgrep='fgrep --color=auto'
# alias egrep='egrep --color=auto'
#
# if command -v vim >/dev/null 2>&1; then
# 	alias vi='vim'
# fi
# if command -v nvim >/dev/null 2>&1; then
# 	alias vim='nvim'
# 	alias vi='nvim'
# fi
# alias purevim='vim -u NONE'
#
# alias ll='\ls -l'
# alias lla='\ls -la'
# alias lt='\ls --color=auto -lhFart'
# if command -v lsd >/dev/null 2>&1; then
# 	alias ls='lsd'
# 	alias ll='lsd -l'
# 	alias lla='lsd -la'
# fi
#
# if command -v z >/dev/null 2>&1; then
# 	alias cd=z
# fi
#
# if [[ -n $TMUX ]]; then
# 	alias fzf='fzf-tmux'
# fi
#
# alias displayoff='xset -display :0.0 dpms force off'
# alias displaylockoff='xdg-screensaver lock; xset -display :0.0 dpms force off'
# alias suspiria='/usr/bin/dbus-send --system --print-reply
#   --dest="org.freedesktop.UPower"
#   /org/freedesktop/UPower
#   org.freedesktop.UPower.Suspend'
#
# # Inspired by: https://codeberg.org/selfawaresoup/configurations/src/branch/main/bash_includes/functions.sh#L71
# function set_tmux_title {
# 	tmux rename-window "$(basename $PWD)"
# }
# # From https://codeberg.org/selfawaresoup/configurations/src/branch/main/bash_includes/functions.sh#L81
# # creates directory and changes into it
# function mdir {
# 	mkdir -p $1 && cd $1
# }
#
# # From: https://codeberg.org/selfawaresoup/configurations/src/branch/main/bash_includes/functions.sh#L86
# # creates an empty file and all the missing directories along its path
# function touchp {
# 	local DIR=$(dirname $1)
# 	mkdir -p $DIR
# 	touch $1
# }
### shell-logout
# # when leaving the console clear the screen to increase privacy
#
# if [ "$SHLVL" = 1 ]; then
#     [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
# fi
#
# # When leaving the console clear the screen to increase privacy. Also clear the
# # scroll-back buffer by switching to tty63 and back.
# case "$(tty)" in
#     /dev/tty[0-9])
#         t=$(v=`tty` ; echo ${v##*ty})
#         clear
#         chvt 63; chvt "$t"
#         ;;
#
#     /dev/tty[0-9][0-9])
#         t=$(v=`tty` ; echo ${v##*ty})
#         clear
#         chvt 63; chvt "$t"
#         ;;
#
#     *)
#         ;;
# esac
## shell-env
#
# ##
# ## Editors
# ##
# export EDITOR=vi
# export GIT_EDITOR="$EDITOR"
# export USE_EDITOR="$EDITOR"
# export VISUAL=$EDITOR
# export PAGER=less
#
# ##
# ## Pager
# ##
# export PAGER=less
# export LESS='-iFMRSX -x4'
#
# if [ -f "$HOME/.shell-env.local" ]; then
#   . "$HOME/.shell-env.local"
# fi
#
# umask 022
### zlogout
# # Via https://tanguy.ortolo.eu/blog/article25/shrc
# #
# # Zsh always executes zshenv. Then, depending on the case:
# # - run as a login shell, it executes zprofile;
# # - run as an interactive, it executes zshrc;
# # - run as a login shell, it executes zlogin.
# #
# # At the end of a login session, it executes zlogout, but in reverse order, the
# # user-specific file first, then the system-wide one, constituting a chiasmus
# # with the zlogin files.
#
# test -r ~/.shell-logout && source ~/.shell-logout
### profile
# # ~/.profile: executed by the command interpreter for login shells.
# # This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# # exists.
# # see /usr/share/doc/bash/examples/startup-files for examples.
# # the files are located in the bash-doc package.
#
# # the default umask is set in /etc/profile; for setting the umask
# # for ssh logins, install and configure the libpam-umask package.
# #umask 022
#
# # if running bash
# if [ -n "$BASH_VERSION" ]; then
#     # include .bashrc if it exists
#     if [ -f "$HOME/.bashrc" ]; then
#         . "$HOME/.bashrc"
#     fi
# fi
#
# # set PATH so it includes user's private bin if it exists
# if [ -d "$HOME/bin" ] ; then
#     PATH="$HOME/bin:$PATH"
# fi
#
# export BREW_PREFIX=/home/linuxbrew/.linuxbrew
# export CHROME_REMOTE_DESKTOP_DEFAULT_DESKTOP_SIZES=1440x900

#
### yadm managed:
# [x] ../../../../.Brewfile##os.Darwin
# [/] ../../../../.arduinoIDE/arduino-cli.yaml
# [.] ../../../../.bash_logout
# [.] ../../../../.bash_profile
# [.] ../../../../.bashrc
# [x] ../../../../.config/alacritty/alacritty.yml
# [x] ../../../../.config/atuin/config.toml
# [x] ../../../../.config/btop/btop.conf
# [/] ../../../../.config/lsd/config.yaml
# [/] ../../../../.config/lsd/themes/solarized.yaml
# [x] ../../../../.config/nix/flake.lock
# [x] ../../../../.config/nix/flake.nix
# [x] ../../../../.config/nix/installed_packages
# [x] ../../../../.config/nix/installed_packages.local##default
# [ ] ../../../../.config/nvim/init.vim
# [.] ../../../../.config/starship.toml
# [ ] ../../../../.config/yadm/bootstrap
# [/] ../../../../.ctags
# [ ] ../../../../.dircolors
# [x] ../../../../.gdbinit
# [ ] ../../../../.gitconfig
# [ ] ../../../../.gitignore_global
# [ ] ../../../../.gitmessage
# [/] ../../../../.local/bin/clang-wrapper##os.Darwin
# [.] ../../../../.profile
# [x] ../../../../.screenrc
# [.] ../../../../.shell-aliases
# [.] ../../../../.shell-common
# [.] ../../../../.shell-common.local##default
# [.] ../../../../.shell-common.local##os.Darwin
# [.] ../../../../.shell-env
# [.] ../../../../.shell-env.local##default
# [.] ../../../../.shell-env.local##os.Darwin
# [.] ../../../../.shell-logout
# [x] ../../../../.tmux.conf
# [ ] ../../../../.vim/undodir/.gitkeep
# [ ] ../../../../.vimrc
# [.] ../../../../.zlogout
# [.] ../../../../.zshenv
# [.] ../../../../.zshrc
# [/] ../../../../LICENSE
# [/] ../../../../README.md
# [x] .colima/default/colima.yaml
# [ ] .config/MusicBrainz/Picard.ini
# [x] .config/htop/htoprc
# [x] .ssh
# [ ] .vscode
# [ ] .wokwi
# [x] .ripgreprc
# Change GOPATH
