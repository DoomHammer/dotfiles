-- FIXME: Document the stuff used here as it's powerful
-- luacheck: push ignore 113
local command = vim.api.nvim_create_user_command
-- luacheck: pop

return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	keys = {
		-- luacheck: push ignore 113
		{ "<leader>fn", vim.cmd.ObsidianQuickSwitch, desc = "open an Obsidian note" },
		-- luacheck: pop
	},
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",

		"hrsh7th/nvim-cmp",
		"nvim-telescope/telescope.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("obsidian").setup({
			dir = "~/Documents/Obsidian/",
			completion = {
				-- Set to false to disable completion.
				nvim_cmp = true,
				-- Trigger completion at 2 chars.
				min_chars = 2,
			},
			daily_notes = {
				folder = "📆",
				date_format = "%Y/%m/%Y-%m-%d",
			},
			-- attachments = {
			-- 	img_folder = "resources",
			-- },
			prepend_note_id = false,
			-- I just want to use titles as file names
			note_id_func = function(title)
				return title
			end,
			mappings = {
				-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
				["gf"] = {
					action = function()
						return require("obsidian").util.gf_passthrough()
					end,
					opts = { noremap = false, expr = true, buffer = true },
				},
				-- Toggle check-boxes.
				["<leader>ch"] = {
					action = function()
						return require("obsidian").util.toggle_checkbox()
					end,
					opts = { buffer = true },
				},
				-- Smart action depending on context, either follow link or toggle checkbox.
				["<cr>"] = {
					action = function()
						return require("obsidian").util.smart_action()
					end,
					opts = { buffer = true, expr = true },
				},
			},
			use_advanced_uri = true,
		})
		-- Borrowed from https://github.com/hallettj/home.nix
		-- /blob/c24e02ebf0ed745b3370b99c135ad4231daf1183/home-manager/features/neovim/nvim-config/lua/plugins/obsidian.lua

		local obsidian_completer = function(callback)
			local client = require("obsidian").get_client()
			return function(arg_lead, cmd_line, cursor_pos)
				local cmd_line_without_command, _ = string.gsub(cmd_line, "^%S+ ", "")
				return callback(client, arg_lead, cmd_line_without_command, cursor_pos)
			end
		end

		-- My version of `LinkNew` avoids a redundant [[title|tite]] if possible,
		-- and combines the functionality of `ObsidianLink` and `ObsidianLinkNew`
		command("Link", function(data)
			local log = require("obsidian.log")
			local client = require("obsidian").get_client()
			-- luacheck: push ignore 113
			local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
			local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
			-- luacheck: pop

			if data.line1 ~= csrow or data.line2 ~= cerow then
				log.err("Link must be called with visual selection")
				return
			end

			-- luacheck: push ignore 113
			local lines = vim.fn.getline(csrow, cerow)
			-- luacheck: pop
			if #lines ~= 1 then
				log.err("Only in-line visual selections allowed")
				return
			end

			local line = lines[1]
			if line == nil then
				return
			end

			local link_text = string.sub(line, cscol, cecol)
			local title
			if string.len(data.args) > 0 then
				title = data.args
			else
				title = link_text
			end
			local note = client:resolve_note(title)
			local note_id = note ~= nil and tostring(note.id) or title

			local updated_line
			if note_id ~= link_text then
				updated_line = string.sub(line, 1, cscol - 1)
					.. "[["
					.. note_id
					.. "|"
					.. link_text
					.. "]]"
					.. string.sub(line, cecol + 1)
			else
				updated_line = string.sub(line, 1, cscol - 1)
					.. "[["
					.. link_text
					.. "]]"
					.. string.sub(line, cecol + 1)
			end
			-- luacheck: push ignore 113
			vim.api.nvim_buf_set_lines(0, csrow - 1, csrow, false, { updated_line })
			-- luacheck: pop
		end, {
			complete = obsidian_completer(require("obsidian.commands").complete_args_search),
			desc = "turn visual selection into a link to a new or existing note",
			nargs = "?",
			range = true,
		})

		command("Note", function(opts)
			local client = require("obsidian").get_client()
			local note = client:resolve_note(opts.args)
			if note ~= nil then
				-- luacheck: push ignore 113
				vim.cmd.edit(note.path.filename)
			-- luacheck: pop
			else
				local new_note_path = opts.args
				local workspace_path = client.current_workspace.path
				local file_path = workspace_path .. "/Inbox/" .. new_note_path .. ".md"
				-- luacheck: push ignore 113
				vim.cmd.edit(file_path)
				-- luacheck: pop
			end
		end, {
			complete = obsidian_completer(require("obsidian.commands").complete_args_search),
			desc = "open an Obsidian note, or create a new one with the given name",
			nargs = 1,
		})
	end,
}
