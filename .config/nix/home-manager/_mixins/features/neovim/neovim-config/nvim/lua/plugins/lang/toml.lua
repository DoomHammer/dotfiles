-- Borrowed from https://github.com/sebastianusk/dotfiles/blob/5bf03213bc8600e8c98d29c347e5bcf64470d680/config/nvim/lua/plugins/lang/toml.lua
local install = require("utls.install")
local lsp = require("utls.lsp")
return {
	install.ensure_installed_mason({ "taplo" }),
	install.ensure_installed_treesitter({ "toml" }),
	lsp.lsp_config_server({
		taplo = {},
	}),
}
