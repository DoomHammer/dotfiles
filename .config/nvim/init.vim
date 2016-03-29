"""
""" Prefer Homebrew Python to system one and both to virtualenv
"""
if executable('brew')
  let python = system('echo -n $(brew --prefix)') . '/bin/python'
  let python3 = system('echo -n $(brew --prefix)') . '/bin/python3'
endif
if executable(python)
  let g:python_host_prog = python
elseif has('mac')
  let g:python_host_prog = '/usr/local/bin/python'
else
  let g:python_host_prog = '/usr/bin/python'
endif
if executable(python3)
  let g:python3_host_prog = python3
elseif has('mac')
  let g:python3_host_prog = '/usr/local/bin/python3'
else
  let g:python3_host_prog = '/usr/bin/python3'
endif
unlet python python3
source ~/.vimrc
