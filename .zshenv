zmodload zsh/zprof

skip_global_compinit=1

ZSH_PLUGIN_MANAGER=zgen

if [[ `brew ls --versions chruby|wc -l` -gt 0 ]];then
  local brew_prefix=$(brew --prefix)
  source $brew_prefix/opt/chruby/share/chruby/chruby.sh
  source $brew_prefix/opt/chruby/share/chruby/auto.sh
fi
