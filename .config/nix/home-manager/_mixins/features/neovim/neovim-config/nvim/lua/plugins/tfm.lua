return {
	{
		"rolv-apneseth/tfm.nvim",
		config = function()
			-- Set keymap so you can open the default terminal file manager (yazi)
			-- luacheck: push ignore 113
			vim.api.nvim_set_keymap("n", "<leader>r", "", {
				-- luacheck: pop
				noremap = true,
				callback = require("tfm").open,
				desc = "Open TFM",
			})
		end,
	},
}
