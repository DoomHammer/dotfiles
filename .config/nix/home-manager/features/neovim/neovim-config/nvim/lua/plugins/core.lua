return {
	-- add solarized
	{ "shaunsingh/solarized.nvim" },
	{
		"LazyVim/LazyVim",
		opts = {
			background = "light",
			colorscheme = "solarized",
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function()
			return {
				theme = "solarized_light",
			}
		end,
	},
}
