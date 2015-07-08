# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd extendedglob nomatch
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/doomhammer/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


export EDITOR=vim
export USE_EDITOR=$EDITOR
export VISUAL=$EDITOR
# FIXME: check first if they are available
export LC_ALL=en_US.UTF-8


# FIXME: allow installation with several open shells
if [[ ! -f ~/.antigen.zsh ]]; then
  curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh > ~/.antigen.zsh
fi
source ~/.antigen.zsh

antigen use oh-my-zsh

antigen bundles <<EOBUNDLES
brew
colored-man
command-not-found
docker
extract
git
golang
pip
python
ssh-agent
sudo
tmuxinator
vagrant
virtualenv

sharat87/autoenv
rimraf/k
EOBUNDLES

antigen theme gentoo

antigen apply

is_linux () {
  [[ $('uname') == 'Linux' ]];
}

is_osx () {
  [[ $('uname') == 'Darwin' ]]
}

if is_osx; then
  export HOMEBREW_CASK_OPTS="--appdir=/Applications"
  if [[ ! -f '/usr/local/bin/brew' ]]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew tap homebrew/boneyard
  fi
elif is_linux; then
  if [[ ! -d $HOME/.linuxbrew ]]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
    brew doctor
  fi

  export PATH=$HOME/.linuxbrew/bin:$PATH
  export PYTHONPATH=$(brew --prefix)/lib/python2.7/site-packages:$PYTHONPATH
fi

setopt interactivecomments

setopt CORRECT

alias tmux='tmux -2'

# TMUX
if [[ -z $TMUX ]]; then
  # Attempt to discover a detached session and attach it, else create a new session
  CURRENT_USER=$(whoami)
  if tmux has-session -t $CURRENT_USER 2>/dev/null; then
    tmux attach-session -t $CURRENT_USER
  else
    tmux new-session -s $CURRENT_USER
  fi
fi

if which exa >/dev/null 2>&1
then
  alias ls='exa'
elif which ls++ >/dev/null 2>&1
then
  alias ls='ls++'
fi

if which nvim >/dev/null 2>&1
then
  alias vim='nvim'
fi

alias ll='ls -l'
if which vim >/dev/null 2>&1
then
  alias vi='vim'
fi

if [ -d $HOME/src/vim-plug-zsh ]; then
  antigen bundle $HOME/src/vim-plug-zsh
  #[ -f ~/.vimrc ] && grep -q 'call plug#begin' ~/.vimrc && vim-plug
fi
