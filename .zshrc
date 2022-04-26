# vim: set ft=zsh sw=2 et :
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

# Thanks to https://github.com/elifarley/shellbase/blob/master/.zshrc
alias make='nocorrect make'

setopt appendhistory
setopt autocd
setopt correct_all
setopt extendedglob
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt interactive_comments
setopt pushd_ignore_dups
setopt promptsubst

# EMACS mode
bindkey -e
# TODO: This might be neat: http://unix.stackexchange.com/a/47425
# TODO: Nice list of bindings: http://zshwiki.org/home/zle/bindkeys
# Make CTRL+Arrow skip words
# rxvt
bindkey "^[Od" backward-word
bindkey "^[Oc" forward-word
# xterm
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
# gnome-terminal
bindkey "^[OD" backward-word
bindkey "^[OC" forward-word

# Ctrl+U to delete the current line before cursor
bindkey "^U" backward-kill-line
# Ctrl+Q to save the current command and switch to a new one
bindkey "^Q" push-line-or-edit

# Ignore interactive commands from history
export HISTORY_IGNORE="(ls|bg|fg|pwd|exit|cd ..|cd -|pushd|popd)"

# FIXME: check first if they are available
export LC_ALL=en_US.UTF-8

fpath=(/usr/share/zsh/vendor-completions/ $fpath)


PROMPT_LEAN_TMUX=""
PROMPT_LEAN_COLOR1="242"
PROMPT_LEAN_COLOR2="blue"

if [ -f $HOME/.nix-profile/init.zsh ]; then
  source $HOME/.nix-profile/init.zsh

  zplug "plugins/ssh-agent", from:oh-my-zsh, ignore:oh-my-zsh.sh
  # Load after ssh-agent
  zplug "plugins/gpg-agent", from:oh-my-zsh, ignore:oh-my-zsh.sh

  zplug "oconnor663/zsh-sensible"
  zplug "zsh-users/zsh-completions"
  zplug "zsh-users/zsh-history-substring-search"
  zplug "zsh-users/zsh-syntax-highlighting", defer:2

  # Install plugins if there are plugins that have not been installed
  if ! zplug check --verbose; then
    printf "Install zsh plugins? [y/N]: "
    if read -q; then
      echo; zplug install
    fi
  fi

  # Then, source plugins and add commands to $PATH
  zplug load # --verbose
fi

if [ -d $BREW_PREFIX ]; then
  eval "$($BREW_PREFIX/bin/brew shellenv)"
  fpath=($BREW_PREFIX/share/zsh/site-functions $fpath)
fi

if [ -d $HOME/.nix-profile ]; then
  . $HOME/.nix-profile/etc/profile.d/nix.sh
  fpath=($HOME/.nix-profile/share/zsh/site-functions $fpath)
fi

test -r ~/.shell-common && source ~/.shell-common
test -r ~/.shell-aliases && source ~/.shell-aliases

if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi

eval "$(direnv hook zsh)"
# Lean doesn't work great with Linux shell (in an actual tty), gonna check how
# this Starship behaves
eval "$(starship init zsh)"
