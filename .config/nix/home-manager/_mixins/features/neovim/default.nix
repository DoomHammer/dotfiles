{
  config,
  flakePath,
  pkgs,
  ...
}:

let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/_mixins/features/neovim";
in
{
  programs.neovim = {
    package = pkgs.unstable.neovim-unwrapped;
    enable = true;
    defaultEditor = true;
    withPython3 = true;
    withNodeJs = true;
    extraPackages = with pkgs; [
      fd
      ripgrep # used by obsidian.nvim, and other plugins

      git
      lazygit

      # needed to compile fzf-native for telescope-fzf-native.nvim
      clang
      gcc
      gnumake

      # needed to compile some Language Servers
      cargo
      nodejs
      python310

      # Lua support
      stylua

      # Ctags
      universal-ctags

      # language servers
      deno
      lua-language-server
      nil # Nix LSP
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      shellcheck # called by bash-language-server

      # Rust support
      lldb # debug adapter
      rust-analyzer

      # Nix support
      nixfmt-rfc-style
      nixpkgs-fmt
      statix
      deadnix

      # Images in terminal and NeoVim
      timg
      viu
    ];
  };

  # programs.lazyvim = {
  #   enable = true;
  #
  #   # Add LSP servers and tools
  #   extraPackages = with pkgs; [
  #     rust-analyzer
  #     gopls
  #     nodePackages.typescript-language-server
  #   ];
  #
  #   # Add treesitter parsers
  #   treesitterParsers = with pkgs.tree-sitter-grammars; [
  #     tree-sitter-rust
  #     tree-sitter-go
  #     tree-sitter-typescript
  #     tree-sitter-tsx
  #   ];
  #
  #   # Maps to lua/config/ directory
  #   config = {
  #     # Custom autocmds → lua/config/autocmds.lua
  #     autocmds = ''
  #       vim.api.nvim_create_autocmd("FocusLost", {
  #         command = "silent! wa",
  #       })
  #
  #       vim.api.nvim_create_user_command("LintInfo", function()
  #         local filetype = vim.bo.filetype
  #         local linters = require("lint").linters_by_ft[filetype]
  #
  #         if linters then
  #           print("Linters for " .. filetype .. ": " .. table.concat(linters, ", "))
  #         else
  #           print("No linters configured for filetype: " .. filetype)
  #         end
  #       end, {})
  #     '';
  #
  #     # Custom keymaps → lua/config/keymaps.lua
  #     keymaps = ''
  #       vim.keymap.set("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
  #     '';
  #
  #     # Custom options → lua/config/options.lua
  #     options = ''
  #       vim.opt.relativenumber = false
  #       vim.opt.wrap = true
  #     '';
  #   };
  #
  #   # Maps to lua/plugins/ directory
  #   plugins = {
  #     # Each key becomes lua/plugins/{key}.lua
  #
  #     aerial = ''
  #       return {
  #         {
  #           "stevearc/aerial.nvim",
  #         },
  #       }
  #     '';
  #
  #     core = ''
  #       return {
  #         -- add solarized
  #         { "shaunsingh/solarized.nvim" },
  #         {
  #           "LazyVim/LazyVim",
  #           opts = {
  #             background = "light",
  #             colorscheme = "solarized",
  #           },
  #         },
  #         {
  #           "nvim-lualine/lualine.nvim",
  #           event = "VeryLazy",
  #           opts = function()
  #             return {
  #               theme = "solarized_light",
  #             }
  #           end,
  #         },
  #       }
  #     '';
  #
  #     lsp-config = ''
  #       return {
  #         "neovim/nvim-lspconfig",
  #         opts = function(_, opts)
  #           opts.servers.rust_analyzer = {
  #             settings = {
  #               ["rust-analyzer"] = {
  #                 checkOnSave = { command = "clippy" },
  #               },
  #             },
  #           }
  #           return opts
  #         end,
  #       }
  #     '';
  #   };
  # };

  xdg.configFile = {
    "nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink "${dir}/neovim-config/nvim/init.lua";
    "nvim/lazyvim.json".source =
      config.lib.file.mkOutOfStoreSymlink "${dir}/neovim-config/nvim/lazyvim.json";
    "nvim/lazy-lock.json".source =
      config.lib.file.mkOutOfStoreSymlink "${dir}/neovim-config/nvim/lazy-lock.json";
    "nvim/lua".source = config.lib.file.mkOutOfStoreSymlink "${dir}/neovim-config/nvim/lua";
  };
}
