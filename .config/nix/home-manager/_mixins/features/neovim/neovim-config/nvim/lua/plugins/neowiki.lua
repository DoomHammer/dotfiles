return {
	"echaya/neowiki.nvim",
	opts = {
		wiki_dirs = {
			{ name = "Obsidian", path = "~/Documents/Obsidian/DoomHammer" },
		},
	},
	keys = {
		{ "<leader>ww", "<cmd>lua require('neowiki').open_wiki()<cr>", desc = "Open Wiki" },
		{ "<leader>wW", "<cmd>lua require('neowiki').open_wiki_floating()<cr>", desc = "Open Wiki in Floating Window" },
		{ "<leader>wT", "<cmd>lua require('neowiki').open_wiki_new_tab()<cr>", desc = "Open Wiki in Tab" },
	},
}
