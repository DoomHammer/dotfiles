return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			-- luacheck: push ignore 113
			vim.list_extend(opts.ensure_installed, {
				-- luacheck: pop
				"bash",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"tsx",
				"typescript",
				"vim",
				"yaml",
			})
		end,
	},
}
