return {
	"L3MON4D3/LuaSnip",
	lazy = true,
	-- luacheck: push ignore 113
	build = (not LazyVim.is_win())
			and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
		or nil,
	-- luacheck: pop
	dependencies = {
		{
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
				-- luacheck: push ignore 113
				require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
				-- luacheck: pop
			end,
		},
	},
	opts = {
		history = true,
		delete_check_events = "TextChanged",
	},
}
