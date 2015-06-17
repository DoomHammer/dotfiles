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
    !./install.sh --clang-completer
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

Plug 'junegunn/fzf'

" Git goodies
Plug 'tpope/vim-fugitive'
" The NerdTree
Plug 'scrooloose/nerdtree' | Plug 'jistr/vim-nerdtree-tabs'
" Nice colours for our Vim
Plug 'altercation/vim-colors-solarized'
" Better session management
Plug 'vim-misc' | Plug 'xolox/vim-session'
" Ag, the SilverSearcher
Plug 'rking/ag.vim'
" Man browser for Vim
Plug 'bruno-/vim-man'
" Without you, I'm nothing
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
" Local configuration for projects
Plug 'embear/vim-localvimrc'
" Dockerfile support
Plug 'docker/docker' , {'rtp': '/contrib/syntax/vim/'}
" Automatic generation of CTags
Plug 'xolox/vim-easytags'
" Nice browser for CTags
Plug 'majutsushi/tagbar'
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
" " DWM-inspired split management
" Bundle 'dwm.vim'
" " Taglist to navigate within a project
" Bundle 'taglist.vim'
" " And of course auto-update of said tags
" Bundle 'AutoTag'
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

" Now configure those plugins
map <Leader>n <plug>NERDTreeTabsToggle<CR>

let g:easytags_async=1
let g:easytags_dynamic_files=1
let g:easytags_suppress_ctags_warning=1

" Session settings for mksession and vim-session
set sessionoptions=blank,buffers,curdir,folds,help,options,resize,tabpages,winpos,winsize

colo seoul256

set expandtab
set shiftwidth=2
set softtabstop=2

" Better autocompletion for filenames, buffers, colors, etc.
set wildmenu
set wildmode=longest:full,full

set list
set listchars=tab:▸\ ,eol:¬

" Work with tmux mouse integration
set mouse=a

if has('nvim')
  colo peachpuff

  set ttimeout
  set ttimeoutlen=0
endif

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
