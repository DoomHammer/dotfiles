// Borrowed from https://github.com/bondzula/nvim/blob/e089fc676c42acb18255fb3432c998d647eae840/lua/plugins/lsp/mason.lua
return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  build = ":MasonUpdate",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  opts = {
    ensure_lsp_installed = {},
    ensure_tools_installed = {},
  },
  config = function(_, opts)
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      automatic_installation = true,
      ensure_installed = opts.ensure_lsp_installed,
    })

    mason_tool_installer.setup({
      ensure_installed = opts.ensure_tools_installed,
    })
  end,
}
