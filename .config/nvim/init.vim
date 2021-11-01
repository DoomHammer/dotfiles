" Configure python provider
let $PYTHONPATH = $HOME . '/.nix-profile/lib/python3.8/site-packages:' . $PYTHONPATH
let g:python3_host_prog = '~/.nix-profile/bin/python'
let g:loaded_python_provider = 0

source ~/.vimrc
