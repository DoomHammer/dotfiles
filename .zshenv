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

##
## Paths
##
typeset -gU cdpath fpath mailpath manpath path
typeset -gUT INFOPATH infopath

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

# WSL cannot handle `nice`
if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null ; then
  unsetopt BG_NICE
fi
