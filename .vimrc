" vim: set sw=2 et :
" Configure plug.vim
if has('nvim')
  let vimplugdir='~/.config/nvim/plugged'
  let vimautoloaddir='~/.config/nvim/autoload'
else
  let vimplugdir='~/.vim/plugged'
  let vimautoloaddir='~/.vim/autoload'
endif

" Install plug.vim
if empty(glob(vimautoloaddir . '/plug.vim'))
  " TODO: else?
  if executable('curl')
    execute 'silent !curl -fLo ' . vimautoloaddir . '/plug.vim --create-dirs ' .
          \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endif

call plug#begin(vimplugdir)

" This is taking care of the plugins
Plug 'junegunn/vim-plug'

" Neovim is sensible by default
if !has('nvim')
  Plug 'tpope/vim-sensible'
endif

" Editing eye-candy
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" Solarized colorscheme
Plug 'altercation/vim-colors-solarized'

" Tmux .conf
Plug 'tmux-plugins/vim-tmux'
" Tmux Focus Events
Plug 'tmux-plugins/vim-tmux-focus-events'

" Automatically detect indentation
Plug 'tpope/vim-sleuth'

if has('nvim')
  " Asynchronous make for neovim
  Plug 'neomake/neomake'
  " Automated code formatter
  Plug 'sbdchd/neoformat'
  " Popup terminal
  Plug 'kassio/neoterm'
  " Nice tree view
  Plug 'kyazdani42/nvim-tree.lua'
  " Icons for the tree view
  Plug 'kyazdani42/nvim-web-devicons'
  " A buffer bar
  Plug 'noib3/nvim-cokeline'
  " Better syntax recognition
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  " LSP config
  Plug 'neovim/nvim-lspconfig'
  " Auto completion
  Plug 'hrsh7th/nvim-compe'
  " Telescope for quick switching
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  " Copliot here
  Plug 'github/copilot.vim'
  " Nice colours for our NeoVim
  Plug 'ishan9299/nvim-solarized-lua'
  " Show indent lines
  Plug 'lukas-reineke/indent-blankline.nvim'
  " Status line
  Plug 'feline-nvim/feline.nvim'
  " Dim inactive windows
  Plug 'sunjon/shade.nvim'
endif

call plug#end()

if has('nvim')
  " Add some colors
  set termguicolors
  colorscheme solarized-high

  " When writing a buffer (no delay), and on normal mode changes (after 750ms).
  call neomake#configure#automake('nw', 750)
  " Call Neomake when writing a buffer (no delay)
  let g:neomake_open_list = 2

  " Configure Cokeline
  lua << EOF
    require('cokeline').setup({
      show_if_buffers_are_at_least = 2
    })

    local map = vim.api.nvim_set_keymap

    map('n', '<S-Tab>',   '<Plug>(cokeline-focus-prev)', { silent = true })
    map('n', '<Tab>',     '<Plug>(cokeline-focus-next)', { silent = true })
    map('n', '<Leader>h', '<Plug>(cokeline-focus-prev)', { silent = true })
    map('n', '<Leader>l', '<Plug>(cokeline-focus-next)', { silent = true })
EOF

  " Configure Terraform LSP
  lua <<EOF
    require'lspconfig'.terraformls.setup{}
EOF
  autocmd BufWritePre *.tf lua vim.lsp.buf.formatting_sync()

  " Configure NvimTree
  lua << EOF
    require('nvim-tree').setup()
EOF
  nmap <leader>n :NvimTreeToggle<CR>

  " Configure Telescope
  lua << EOF
    require('telescope').load_extension('fzf')
EOF
  " Find files using Telescope command-line sugar.
  nnoremap <leader>ff <cmd>Telescope find_files<cr>
  nnoremap <leader>fg <cmd>Telescope live_grep<cr>
  nnoremap <leader>fb <cmd>Telescope buffers<cr>
  nnoremap <leader>fh <cmd>Telescope help_tags<cr>

  " Configure tree-sitter with folding
  lua <<EOF
    require('nvim-treesitter.install').compilers = { 'clang++'}
    require('nvim-treesitter.configs').setup({
      -- One of "all", "maintained" (parsers with maintainers), or a list of languages
      ensure_installed = "maintained",
      ignore_install = { "godot_resource", "teal" },
    })
EOF
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()

  " Configure Neoformat to run automatically on buffer write
  augroup fmt
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat
  augroup END

  " Configure feline
  lua <<EOF
    require('feline').setup()
EOF

  " Configure Shade
  lua <<EOF
    require('shade').setup({
      overlay_opacity = 50,
      opacity_step = 1,
      keys = {
        brightness_up    = '<C-Up>',
        brightness_down  = '<C-Down>',
        toggle           = '<Leader>s',
      }
    })
EOF
endif

set background=light
" Keep at least 5 lines anove or below the cursor
set scrolloff=5

" use F2 to switch to paste mode
set pastetoggle=<F2>

" Configure Goyo
nmap <leader>] :Goyo<CR>
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

" Configure Limelight
let g:limelight_conceal_ctermfg = 245 " Solarized Base1
let g:limelight_conceal_guifg = '#8a8a8a' " Solarized Base1

"""
""" Visually indicate long columns
""" Taken from https://www.youtube.com/watch?v=aHm36-na4-4
"""
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 100)

" Prefer two spaces
set shiftwidth=2
set softtabstop=2

" Show me those tabs, BTW
set list
set listchars=trail:~,nbsp:␣,tab:▸\

" Easy moves through wrapped lines
nnoremap j gj
nnoremap k gk

" Work with tmux mouse integration
set mouse=a

set undodir=~/.vim/undodir
set undofile
