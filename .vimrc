if has('nvim')
  let vimplugdir='~/.nvim/plugged'
else
  let vimplugdir='~/.vim/plugged'
endif


function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py --clang-completer
    "!./install.sh --clang-completer --gocode-completer --omnisharp-completer
  endif
endfunction

function! UpdateRemote(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    UpdateRemotePlugins
    echom "Remeber to restart!"
  endif
endfunction

call plug#begin(vimplugdir)

Plug 'tpope/vim-sensible'
Plug 'neilagabriel/vim-geeknote'

" Make sure you use single quotes
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'tpope/vim-tbone'
Plug 'junegunn/vim-peekaboo'

" I see your true colors...
Plug 'junegunn/seoul256.vim'

" Fuzzy searching
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Git goodies
Plug 'tpope/vim-fugitive'
" The NerdTree
Plug 'scrooloose/nerdtree' | Plug 'jistr/vim-nerdtree-tabs'
" Nice colours for our Vim
Plug 'altercation/vim-colors-solarized'
" Ag, the SilverSearcher
Plug 'rking/ag.vim'
" Man browser for Vim
Plug 'bruno-/vim-man'
" Without you, I'm nothing
Plug 'Valloric/YouCompleteMe', {'do': function('BuildYCM')}
" Local configuration for projects
Plug 'embear/vim-localvimrc'
" Dockerfile support
Plug 'docker/docker' , {'rtp': '/contrib/syntax/vim/'}
" Automatic generation of CTags
Plug 'vim-misc' | Plug 'xolox/vim-easytags'
" Nice browser for CTags
Plug 'majutsushi/tagbar'
" Tmux .conf
Plug 'tmux-plugins/vim-tmux'
" Tmux Focus Events
Plug 'tmux-plugins/vim-tmux-focus-events'
" Nice status bar
Plug 'bling/vim-airline'
" Automatically save session
Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
" Highlight trailing whitespace
Plug 'ntpeters/vim-better-whitespace'
" Vim color scheme designed to be very readable in both light and dark
" environments.
Plug 'gregsexton/Atom'
" " CoffeeScript support in Vim
" Bundle 'kchmck/vim-coffee-script'
" " EasyMotion
" Bundle 'Lokaltog/vim-easymotion'
" " Vim Outliner
" Bundle 'vimoutliner/vimoutliner'
" " Python mode
" Bundle 'klen/python-mode'
" " What's a snake without Jedi powers?
" Bundle 'DoomHammer/jedi-vim'
" " Jade support
" Bundle 'jade.vim'
" " VCS
" Bundle 'vcscommand.vim'
" " C# Compiler support
" Bundle 'gmcs.vim'
" " Compilation of lonely files
" Bundle 'SingleCompile'
" " EditorConfig
" Bundle 'editorconfig/editorconfig-vim'
"
if has('nvim')
  " Great lldb interface for neovim
  Plug 'critiqjo/lldb.nvim', { 'do': function('UpdateRemote') }
  " Asynchronous make for neovim
  Plug 'benekastah/neomake'
endif

call plug#end()

"""
""" Now configure those plugins
"""
map <Leader>n <plug>NERDTreeTabsToggle<CR>

let g:easytags_async=1
let g:easytags_dynamic_files=1
let g:easytags_suppress_ctags_warning=1

" Default fzf layout
let g:fzf_layout = { 'down': '40%' }

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Session settings
set sessionoptions=buffers,curdir,folds,help,resize,tabpages,winpos,winsize

let g:prosession_on_startup = 1
let g:prosession_tmux_title = 1

"""
"""
"""

" Use system Python even in Virtualenv
let g:python_host_prog='/usr/bin/python'

colo atom

"""
""" Fun with buffers
""" Based on https://joshldavis.com/2014/04/05/vim-tab-madness-buffers-vs-tabs/
"""
set hidden


" To open a new empty buffer
nmap <leader>T :enew<cr>

" Move to the next buffer
nmap <leader>l :bnext<CR>

" Move to the previous buffer
nmap <leader>h :bprevious<CR>

" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>bq :bp <BAR> bd #<CR>

" Show all open buffers with FZF
nmap <leader>bl :Buffers<CR>

nmap <leader>t :TagbarToggle<CR>
nmap <leader>n :NERDTreeTabsToggle<CR>

set expandtab
set shiftwidth=2
set softtabstop=2

" Better autocompletion for filenames, buffers, colors, etc.
set wildmenu
set wildmode=longest:full,full

set list
set listchars=tab:▸\ 

set clipboard=unnamed

" Work with tmux mouse integration
set mouse=a

if has('nvim')
  set ttimeout
  set ttimeoutlen=0
endif

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
