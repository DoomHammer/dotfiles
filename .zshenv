zmodload zsh/zprof

skip_global_compinit=1

##
## Editors
##
export EDITOR=vi
export USE_EDITOR=$EDITOR
export VISUAL=$EDITOR
export PAGER=less

##
## Paths
##

typeset -gU cdpath fpath mailpath manpath path
typeset -gUT INFOPATH infopath

BREW_PREFIX=$HOME/.linuxbrew
export GOPATH=$HOME/.go:$HOME

cdpath=(
  $HOME/src
  $cdpath
)

infopath=(
  $BREW_PREFIX/share/info
  /usr/local/share/info
  /usr/share/info
  $infopath
)

manpath=(
  $BREW_PREFIX/share/man
  /usr/local/share/man
  /usr/share/man
  $manpath
)

path=(
  $BREW_PREFIX/{bin,sbin}
  ${GOPATH//://bin:}/bin
  /usr/local/{bin,sbin}
  /usr/{bin,sbin}
  /{bin,sbin}
  $path
)

if [[ `brew ls --versions chruby|wc -l` -gt 0 ]];then
  local brew_prefix=$(brew --prefix)
  source $brew_prefix/opt/chruby/share/chruby/chruby.sh
  source $brew_prefix/opt/chruby/share/chruby/auto.sh
fi
