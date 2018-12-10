if has('nvim')
  let vimplugdir='~/.config/nvim/plugged'
  let vimautoloaddir='~/.config/nvim/autoload'
  " TODO: pip2 install neovim
  " TODO: pip3 install neovim
else
  let vimplugdir='~/.vim/plugged'
  let vimautoloaddir='~/.vim/autoload'
endif

" TODO: make swapfiles reside in one directory
"
if empty(glob(vimautoloaddir . '/plug.vim'))
  " TODO: else?
  if executable('curl')
    execute 'silent !curl -fLo ' . vimautoloaddir . '/plug.vim --create-dirs ' .
          \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall
  endif
endif

""
"" Helper functions
""
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
    if executable('npm') && executable('tern')
      let l:cmd .= ' --tern-completer'
    endif
    if executable('clang')
      let l:cmd .= ' --clang-completer'
      let l:cmd = '(export CC=$(which clang); export CXX=$(which clang++); ' . l:cmd . ')'
    endif
    " FIXME: Make it return the success/failure of an installation
    execute BrewWrap(l:cmd)
  endif
endfunction

function! InstallTern(info)
  if executable('brew') && !executable('npm')
    execute "!brew install node"
  endif
  if executable('npm')
    execute "!npm install"
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

try
call plug#begin(vimplugdir)

" Neovim is sensible by default
if !has('nvim')
  Plug 'tpope/vim-sensible'
endif
if has('python')
  Plug 'neilagabriel/vim-geeknote'
endif

" Make sure you use single quotes
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'tpope/vim-tbone'
Plug 'junegunn/vim-peekaboo'
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
if (version == 704 && has('patch154')) || (version > 704) || (has('nvim'))
  if executable('cmake') && executable('python') && executable('make') && executable('cc') && executable('c++')
    Plug 'Valloric/YouCompleteMe', {'do': function('BuildYCM')}
  endif
endif
" Local configuration for projects
Plug 'embear/vim-localvimrc'
" Dockerfile support
Plug 'ekalinin/Dockerfile.vim'
" Automatic generation of CTags
Plug 'vim-scripts/vim-misc' | Plug 'xolox/vim-easytags'
" Automatic update of CTags
Plug 'craigemery/vim-autotag'
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
" Git explorer
Plug 'gregsexton/gitv'
" Ability to :SudoWrite? Priceless!
Plug 'tpope/vim-eunuch'
" Some syntax checking maybe?
Plug 'vim-syntastic/syntastic'
" Close all buffers but current
Plug 'muziqiushan/bufonly'
" Enhanced Commentify
Plug 'vim-scripts/EnhCommentify.vim'
" Magit
Plug 'jreybert/vimagit'
" And gitgutter
Plug 'airblade/vim-gitgutter'
" Ruby goodness
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-bundler'
" Run relevant RSpec cases
Plug 'thoughtbot/vim-rspec'
" Automatically detect indentation
Plug 'tpope/vim-sleuth'

" Task dispatcher
Plug 'tpope/vim-dispatch'

Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" Ansible support
Plug 'chase/vim-ansible-yaml'

" Auto-close scopes
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-endwise'

" JavaScript support
Plug 'jelera/vim-javascript-syntax'
Plug 'pangloss/vim-javascript'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'marijnh/tern_for_vim', {'do': function('InstallTern')}

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
  Plug 'neomake/neomake'
  " Popup terminal
  Plug 'kassio/neoterm'
  " Use Neovim Terminal with Dispatch
  Plug 'radenling/vim-dispatch-neovim'
  " Nice colours for our Vim
  Plug 'icymind/NeoSolarized'
endif

call plug#end()
" FIXME: endless loop?
catch
  " source ~/.vimrc
endtry

"""
""" Now configure those plugins
"""

if executable('ag')
  let g:ackprg = 'ag --vimgrep --smart-case'
endif
nnoremap <Leader>a :Ack!<Space>

"map <Leader>n <plug>NERDTreeTabsToggle<CR>
map <Leader>n <plug>NERDTreeToggle<CR>

set tags=./tags,.vimtags,~/.vim/tags;
set conceallevel=1
set foldmethod=syntax
set pastetoggle=<F2>

let g:easytags_async=1
let g:easytags_file="~/.vim/tags"
let g:easytags_dynamic_files=2
let g:easytags_suppress_ctags_warning=1

" Tagbar definitions
let g:tagbar_type_ansible = {
    \ 'ctagstype' : 'ansible',
    \ 'kinds' : [
        \ 't:tasks'
    \ ],
    \ 'sort' : 0
    \ }

let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : 'markdown2ctags',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

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
let g:syntastic_mode_map = { 'passive_filetypes': ['python'] }

" Show docs
let g:javascript_plugin_jsdoc = 1
" Enable keyboard shortcuts
let g:tern_map_keys=1
" Show argument hints
let g:tern_show_argument_hints='on_hold'
" No Flow as yet (https://flowtype.org/)
" let g:javascript_plugin_flow = 1

let g:javascript_conceal_function             = "ƒ"
let g:javascript_conceal_null                 = "ø"
let g:javascript_conceal_this                 = "@"
let g:javascript_conceal_return               = "⇚"
let g:javascript_conceal_undefined            = "¿"
let g:javascript_conceal_NaN                  = "ℕ"
let g:javascript_conceal_prototype            = "¶"
let g:javascript_conceal_static               = "•"
let g:javascript_conceal_super                = "Ω"
let g:javascript_conceal_arrow_function       = "⇒"

" Match block delimiters for Ruby and C-like languages
let b:delimitMate_expand_cr = 1
execute "inoremap {<CR> {<CR>}<ESC>O"

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

if has('nvim')
  autocmd! BufReadPost,BufWritePost * Neomake
  autocmd! VimLeave * let g:neomake_verbose = 0
endif

autocmd BufRead,BufNewFile *.{markdown,md,mkd} call SetMarkdownOptions()
function! SetMarkdownOptions()
  setlocal spell
  setlocal fo+=t
  setlocal fo-=l
  setlocal textwidth=80
endfunction

autocmd FileType ruby call SetRubyOptions()
function! SetRubyOptions()
  compiler ruby
  setlocal expandtab
  setlocal tabstop=2 shiftwidth=2 softtabstop=2
  setlocal autoindent
endfunction


" Run rspec in tslime.vim
"let g:rspec_command = 'call Send_to_Tmux("[ -n \"$ZSH_VERSION\" ] && unsetopt correct && unsetopt correct_all\n") | call Send_to_Tmux("bundle exec rspec {spec}\n")'
let g:rspec_command = 'Dispatch bundle exec rspec {spec}'
autocmd FileType gitcommit call SetGitComitOptions()
function! SetGitCommitOptions()
  setlocal spell
  setlocal textwidth=72
endfunction()

" Configure tslime
" Currently you have to manually open a pane and enter its number when first
" run. It might be a better idea to open one automatically
let g:tslime_always_current_session = 1
let g:tslime_always_current_window = 1

" vim-rspec mappings
map <Leader>r :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

autocmd filetype python set expandtab

"""
""" Misc definitions
"""

set scrolloff=5

"""
""" Colorscheme
"""
set background=dark
let use_truecolor=0
if exists('$TMUX')
  let s:tmux_version = split(split(system('tmux -V'))[-1], '\.')
  let s:tmux_version_major = s:tmux_version[0]
  let s:tmux_version_minor = s:tmux_version[1]
  if ((s:tmux_version_major >= 2) && (s:tmux_version_minor >= 2))
    let use_truecolor=1
  else
    let use_truecolor=0
  endif
endif
if use_truecolor
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif
if has('nvim')
  set t_8f=[38;2;%lu;%lu;%lum]
  set t_8b=[48;2;%lu;%lu;%lum]
  let g:neosolarized_contrast = "high"
  colorscheme NeoSolarized
else
  try
    set t_Co=256
    let g:solarized_termcolors = 256
    colorscheme solarized
  catch
    colorscheme desert
  endtry
endif
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
nmap <leader>bQ :bp <BAR> bd! #<CR>

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


set shiftwidth=2
set softtabstop=2

" Better autocompletion for filenames, buffers, colors, etc.
set wildmenu
set wildmode=longest:full,full

set list
set listchars=tab:▸\ 

set clipboard=unnamed

" Use ; just like :
nnoremap ; :

" Easy moves through wrapped lines
nnoremap j gj
nnoremap k gk

" Prefer A-a as C-a is taken by Tmux/Screen
nnoremap <A-a> <C-a>
nnoremap <A-x> <C-x>

" Hide last search highlights
nmap <silent> <leader>/ :nohlsearch<CR>

" Work with tmux mouse integration
set mouse=a

if has('nvim')
  set ttimeout
  set ttimeoutlen=0

  tnoremap <Esc> <C-\><C-n>
endif

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
