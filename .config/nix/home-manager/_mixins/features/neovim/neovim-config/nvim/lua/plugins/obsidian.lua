return {
	"obsidian-nvim/obsidian.nvim",
	-- version = "*",  -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"saghen/blink.cmp",
		"ibhagwan/fzf-lua",
	},
	---@module 'obsidian'
	---@type obsidian.config
	opts = {
		legacy_commands = false, -- this will be removed in 4.0.0
		note_id_func = function(title)
			require("obsidian.builtin").title_id(title)
		end,
		workspaces = {
			{
				name = "DoomHammer",
				path = "~/Documents/Obsidian/DoomHammer/",
			},
			{
				name = "Evernote",
				path = "~/Documents/Obsidian/Evernote Importer/",
			},
		},

		picker = {
			-- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
			name = "fzf-lua",
			-- Optional, configure key mappings for the picker. These are the defaults.
			-- Not all pickers support all mappings.
			note_mappings = {
				-- Create a new note from your query.
				new = "<C-x>",
				-- Insert a link to the selected note.
				insert_link = "<C-l>",
			},
			tag_mappings = {
				-- Add tag(s) to current note.
				tag_note = "<C-x>",
				-- Insert a tag at the current location.
				insert_tag = "<C-l>",
			},
		},
		attachments = {
			folder = "./resources",
		},
		daily_notes = {
			enabled = true,
			folder = "📆",
			date_format = "YYYY/MM/YYYY-MM-DD",
			default_tags = { "journal", "daily" },
			-- template = "daily-note.md",
		},
	},
}
