if has('nvim')
  let vimplugdir='~/.config/nvim/plugged'
else
  let vimplugdir='~/.vim/plugged'
endif


function! BrewWrap(command)
  if executable('brew')
    execute "!brew sh <<<'" . a:command . "'"
  else
    execute "!" . a:command
  endif
endfunction

function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.status == 'updated' || a:info.force
    let l:cmd = './install.py'
    if executable('go')
      let l:cmd .= ' --gocode-completer'
    endif
    if executable('cargo')
      let l:cmd .= ' --racer-completer'
    endif
    " Those two are not very nice yet
"    if executable('xbuild') || executable('msbuild')
"      let l:cmd .= ' --omnisharp-completer'
"    endif
"    if executable('npm')
"      let l:cmd .= ' --tern-completer'
"    endif
    if executable('clang')
      let l:cmd .= ' --clang-completer'
      let l:cmd = '(export CC=$(which clang); export CXX=$(which clang++); ' . l:cmd . ')'
    endif
    call BrewWrap(l:cmd)
  endif
endfunction

function! UpdateRemote(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    UpdateRemotePlugins
    echom "Remember to restart!"
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
" Ag, the SilverSearcher through his friend Ack
Plug 'mileszs/ack.vim'
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
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
" Automatically save session
Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
" Highlight trailing whitespace
Plug 'ntpeters/vim-better-whitespace'
" Vim color scheme designed to be very readable in both light and dark
" environments.
Plug 'gregsexton/Atom'
" Git explorer
Plug 'gregsexton/gitv'
" Ability to :SudoWrite? Priceless!
Plug 'tpope/vim-eunuch'
" Some syntax checking maybe?
Plug 'vim-syntastic/syntastic'
" Close all buffers but current
Plug 'muziqiushan/bufonly'
" Enhanced Commentify
Plug 'EnhCommentify.vim'
" Magit
Plug 'jreybert/vimagit'
" And gitgutter
Plug 'airblade/vim-gitgutter'
" Automatically detect indentation
Plug 'tpope/vim-sleuth'

Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

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

if has('nvim')
  " Great lldb interface for neovim
  Plug 'critiqjo/lldb.nvim', { 'do': function('UpdateRemote') }
  " Asynchronous make for neovim
  Plug 'benekastah/neomake'
  " Popup terminal
  Plug 'kassio/neoterm'
endif

call plug#end()

"""
""" Now configure those plugins
"""

if executable('ag')
  let g:ackprg = 'ag --vimgrep --smart-case'
endif
cnoreabbrev ag Ack
cnoreabbrev aG Ack
cnoreabbrev Ag Ack
cnoreabbrev AG Ack
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>

"map <Leader>n <plug>NERDTreeTabsToggle<CR>
map <Leader>n <plug>NERDTreeToggle<CR>

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


let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

function! s:goyo_enter()
  if exists('$TMUX')
    " Hide the status panel and zoom in the current pane
    silent !tmux set status off
    " This hackery checks whether the pane is zoomed and toggles the status if
    " not
    silent !tmux list-panes -F '\#F'|grep -q Z || tmux resize-pane -Z
  endif
  " All eyes on me
  Limelight
  " Resize after zoom
  if !exists("g:goyo_width")
    let g:goyo_width=80
  endif
  if !exists("g:goyo_height")
    let g:goyo_height='85%'
  endif
  execute "Goyo ".g:goyo_width."x".g:goyo_height
  set scrolloff=999
endfunction

function! s:goyo_leave()
  if exists('$TMUX')
    " Show the status panel and zoom out the current pane
    silent !tmux set status on
    silent !tmux list-panes -F '\#F'|grep -q Z && tmux resize-pane -Z
  endif
  Limelight!
  set scrolloff=5
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

"""
""" Misc definitions
"""

set scrolloff=5

"""
""" Colorscheme
"""
set background=dark
colo solarized
let g:airline_theme='solarized'
let g:limelight_conceal_ctermfg = 245 " Solarized Base1
let g:limelight_conceal_guifg = '#8a8a8a' " Solarized Base1

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

" Default GitGutter mappings clash with buffer navigation
map <leader>ga <Plug>GitGutterStageHunk
map <leader>gu <Plug>GitGutterUndoHunk

nmap <leader>] :Goyo<CR>

"""
""" Visually indicate long columns
""" Taken from https://www.youtube.com/watch?v=aHm36-na4-4
"""
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 100)

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
