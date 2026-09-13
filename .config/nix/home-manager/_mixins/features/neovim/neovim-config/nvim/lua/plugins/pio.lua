return {
	"anurag3301/nvim-platformio.lua",
	dependencies = {
		{ "akinsho/toggleterm.nvim" },
		{ "nvim-lua/plenary.nvim" },
		{
			-- WhichKey helps you remember your Neovim keymaps,
			-- by showing available keybindings in a popup as you type.
			"folke/which-key.nvim",
		},
		{ "nvim-treesitter/nvim-treesitter" },
		{ "folke/snacks.nvim", opts = {
			picker = { enabled = true, ui_select = true },
		} },
	},
}
