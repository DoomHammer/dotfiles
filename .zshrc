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

bindkey -e

export EDITOR=vi
export USE_EDITOR=$EDITOR
export VISUAL=$EDITOR
# FIXME: check first if they are available
export LC_ALL=en_US.UTF-8

is_linux () {
  [[ $('uname') == 'Linux' ]];
}

is_osx () {
  [[ $('uname') == 'Darwin' ]]
}

fpath=(/usr/share/zsh/vendor-completions/ $fpath)

if is_osx; then
  export HOMEBREW_CASK_OPTS="--appdir=/Applications"
  if [[ ! -f '/usr/local/bin/brew' ]]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew tap homebrew/boneyard
  fi
elif is_linux; then
  local BREW_PREFIX=$HOME/.linuxbrew
  export PATH=$BREW_PREFIX/bin:$BREW_PREFIX/sbin:$BREW_PREFIX/share/python:$PATH
  if [[ ! -d $BREW_PREFIX ]]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/linuxbrew/go/install)"
    brew doctor
    mkdir -p $BREW_PREFIX/share/zsh/site-functions
    ln -s $BREW_PREFIX/Library/Contributions/brew_zsh_completion.zsh $BREW_PREFIX/share/zsh/site-functions/_brew
  fi

  export PYTHONPATH=$BREW_PREFIX/lib/python2.7/site-packages:$PYTHONPATH
  export XDG_DATA_DIRS=$BREW_PREFIX/share:$XDG_DATA_DIRS
  export XML_CATALOG_FILES=$BREW_PREFIX/etc/xml/catalog
  export ANDROID_HOME=$BREW_PREFIX/opt/android-sdk
  export MONO_GAC_PREFIX=$BREW_PREFIX
  fpath=($BREW_PREFIX/share/zsh/site-functions $fpath)
fi

PROMPT_LEAN_TMUX=""
ENHANCD_COMMAND="ecd"

export ZPLUG_HOME=$BREW_PREFIX/opt/zplug

if [ -f $ZPLUG_HOME/init.zsh ]; then
  source $ZPLUG_HOME/init.zsh

  zplug "plugins/command-not-found", from:oh-my-zsh, ignore:oh-my-zsh.sh
  zplug "plugins/extract", from:oh-my-zsh, ignore:oh-my-zsh.sh
  zplug "plugins/pip", from:oh-my-zsh, ignore:oh-my-zsh.sh
  zplug "plugins/python", from:oh-my-zsh, ignore:oh-my-zsh.sh
  zplug "plugins/ssh-agent", from:oh-my-zsh, ignore:oh-my-zsh.sh
  # Load after ssh-agent
  zplug "plugins/gpg-agent", from:oh-my-zsh, ignore:oh-my-zsh.sh
  zplug "plugins/sudo", from:oh-my-zsh, ignore:oh-my-zsh.sh
  zplug "plugins/vagrant", from:oh-my-zsh, ignore:oh-my-zsh.sh
  zplug "plugins/virtualenv", from:oh-my-zsh, ignore:oh-my-zsh.sh

  zplug "b4b4r07/enhancd"
  zplug "caarlos0/zsh-mkc"
  zplug "joel-porquet/zsh-dircolors-solarized"
  zplug "marzocchi/zsh-notify", use:"notify.plugin.zsh"
  zplug "mrowa44/emojify", as:command
  zplug "oconnor663/zsh-sensible"
  zplug "rimraf/k"
  zplug "sharat87/autoenv"
  zplug "zlsun/solarized-man"
  zplug "zsh-users/zsh-completions"
  zplug "zsh-users/zsh-history-substring-search"
  zplug "zsh-users/zsh-syntax-highlighting", nice:19

  zplug "DoomHammer/gogh", use:"themes/solarized.dark.sh", at:"overall"

  if [[ $(brew ls --versions fzf|wc -l) -gt 0 ]]; then
    zplug "$(brew --prefix fzf)/shell", from:local
  fi

  zplug "miekg/lean"

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

if [[ ! -f $HOME/.zsh-dircolors.config ]]; then
  setupsolarized dircolors.256dark
fi

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
if [[ `tmux -V |cut -d ' ' -f2` -ge 2.1 ]]; then
  alias tmux='tmux -2 -f ~/.config/tmux/tmux-2.1.conf'
else
  alias tmux='tmux -2 -f ~/.config/tmux/tmux-2.0.conf'
fi

# Teleconsole does not preserve TMUX env variable
if [[ -z "$TMUX" ]] && [[ -z "$TELEPORT_SESSION" ]]; then
  # Attempt to discover a detached session and attach it, else create a new
  # session
  CURRENT_USER=$(whoami)
  if tmux has-session -t $CURRENT_USER 2>/dev/null; then
    tmux attach-session -t $CURRENT_USER
  else
    tmux new-session -s $CURRENT_USER
  fi
fi

if which exa >/dev/null 2>&1; then
  alias ls='exa'
elif which ls++ >/dev/null 2>&1; then
  alias ls='ls++'
else
  alias ls='ls --color=auto'
fi

if which nvim >/dev/null 2>&1; then
  alias vim='nvim'
fi

alias ll='ls -l'
if which vim >/dev/null 2>&1; then
  alias vi='vim'
fi

if [[ ! -z $TMUX ]]; then
  alias fzf='fzf-tmux'
fi

if [[ -x `which ag` ]]; then
  export FZF_DEFAULT_COMMAND='ag -l -g ""'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
export FZF_DEFAULT_OPTS="--extended-exact"

# v - open files in ~/.viminfo and ~/.nviminfo
v() {
  local files
  files=$(grep --no-filename '^>' ~/.viminfo ~/.nviminfo | cut -c3- |
          while read line; do
            [ -f "${line/\~/$HOME}" ] && echo "$line"
          done | fzf -d -m -q "$*" -1) && vim ${files//\~/$HOME}
}
