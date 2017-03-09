# Via https://tanguy.ortolo.eu/blog/article25/shrc
#
# At startup, depending on the case:
# - run as a login shell (or with the option --login), it executes profile (or
# bash_profile instead if it exists (only user-specific version));
# - run as an interactive, non-login shell, it executes bashrc (the system-wide
# version is called bash.bashrc).
#
# At exit, it executes ~/.bash_logout (the system-wide version is called
# bash.bash_logout).
# Note the funny (read: insane) non-login condition for executing bashrc: it is
# often worked around by having the profile execute bashrc anyway.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Source global definitions
test -r /etc/bashrc && . /etc/bashrc

test -r ~/.shell-env && . ~/.shell-env
test -r ~/.shell-aliases && . ~/.shell-aliases
test -r ~/.shell-common && . ~/.shell-common

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth
export HISTIGNORE="&:ls:[bf]g:pwd:exit:cd .."

# append to the history file, don't overwrite it
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# Store multiline commands as one line.
shopt -s cmdhist

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Spellcheck directories
shopt -s dirspell

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color) color_prompt=yes;;
  screen-256color) color_prompt=yes;;
  screen) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
test -f /usr/share/bash-completion/bash_completion && . /usr/share/bash-completion/bash_completion
test -f /etc/bash_completion && . /etc/bash_completion
test -f $BREW_PREFIX/etc/bash_completion && . $BREW_PREFIX/etc/bash_completion

test -r ~/.bashrc.local && . ~/.bashrc.local
