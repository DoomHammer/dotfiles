-- Borrowed from https://github.com/sebastianusk/dotfiles/blob/5bf03213bc8600e8c98d29c347e5bcf64470d680/config/nvim/lua/plugins/lang/md.lua
local install = require("utls.install")
local lsp = require("utls.lsp")
return {
	install.ensure_installed_mason({
		"marksman",
		"vale",
		"prettier",
	}),
	install.ensure_installed_treesitter({ "markdown" }),
	lsp.lsp_config_server({
		marksman = {},
	}),
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				md = { "prettier" },
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		optional = true,
		opts = {
			linters_by_ft = {
				markdown = { "markdownlint" },
			},
		},
	},
}
