" vim: set sw=2 et :

" Configure plug.vim
if has('nvim')
  let vimautoloaddir='~/.config/nvim/site/autoload'
else
  let vimautoloaddir='~/.vim/autoload'
endif

call plug#begin()

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
  " Mason is now preferred over LSP Installer
  Plug 'williamboman/mason.nvim'
  " LSP config
  Plug 'junnplus/nvim-lsp-setup'
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/mason-lspconfig.nvim'
  " Auto completion
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  " Snippets
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'rafamadriz/friendly-snippets'
  " Telescope for quick switching
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  " Copliot here
  Plug 'github/copilot.vim'
  " Nice colours for our NeoVim
  Plug 'ishan9299/nvim-solarized-lua'
  Plug 'shaunsingh/solarized.nvim'

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

  " Configure completion and LSP
  set completeopt=menu,menuone,noselect
  autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 4000)

  lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'vsnip' },
    }, {
      { name = 'buffer' },
    })
  })

  require("mason").setup({
    automatic_installation = true,
  })
  require('nvim-lsp-setup').setup({
    servers = {
      bashls = {},
      clangd = {},
      cmake = {},
      cssls = {},
      dockerls = {},
      gopls = {},
      grammarly = {},
      jsonls = {},
      html = {},
      pylsp = {},
      sumneko_lua = {},
      terraformls = {},
      tflint = {},
      tsserver = {},
      vimls = {},
      yamlls = {},
    },
    capabilities = vim.lsp.protocol.make_client_capabilities(),
  })
EOF

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
    if vim.loop.os_uname().sysname == "Darwin" then
      require('nvim-treesitter.install').compilers = { os.getenv("HOME")..'/.local/bin/clang-wrapper' }
    end
    require('nvim-treesitter.configs').setup({
      -- One of "all", or a list of languages
      ensure_installed = "all",
      ignore_install = { "godot_resource", "teal" },
      highlight = {
        enable = true
      },
      indent = {
        enable = true
      },
    })
EOF
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()

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

if has('nvim')
  set undodir=~/.config/nvim/undodir
else
  set undodir=~/.vim/undodir
endif
set undofile
