return {
	"saghen/blink.cmp",
	dependencies = {
		"moyiz/blink-emoji.nvim",
		"joelazar/blink-calc",
		"archie-judd/blink-cmp-words",
		"rafamadriz/friendly-snippets",
		"disrupted/blink-cmp-conventional-commits",
	},

	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		fuzzy = {
			implementation = "prefer_rust_with_warning",
		},
		snippets = {
			preset = "luasnip", -- or luasnip, mini.snippets
			-- Function to use when expanding LSP provided snippets
			expand = function(snippet)
				-- luacheck: push ignore 113
				vim.snippet.expand(snippet)
				-- luacheck: pop
			end,
			-- Function to use when checking if a snippet is active
			active = function(filter)
				-- luacheck: push ignore 113
				return vim.snippet.active(filter)
				-- luacheck: pop
			end,
			-- Function to use when jumping between tab stops in a snippet, where direction can be negative or positive
			jump = function(direction)
				-- luacheck: push ignore 113
				vim.snippet.jump(direction)
				-- luacheck: pop
			end,
		},
		sources = {
			default = {
				"conventional_commits",
				"lsp",
				"path",
				"snippets",
				"buffer",
				"thesaurus",
				"omni",
				"cmdline",
				"calc",
				"emoji",
			},
			-- NOTE: no need if you don't have custom markdown stuff
			per_filetype = {
				text = { "dictionary" },
				markdown = {
					"lsp", -- NOTE: explicitly enable lsp
					inherit_defaults = true, -- NOTE: if your defaults include lsp
					"dictionary",
					"thesaurus",
				},
			},
			providers = {
				conventional_commits = {
					name = "Conventional Commits",
					module = "blink-cmp-conventional-commits",
					enabled = function()
						-- luacheck: push ignore 113
						return vim.bo.filetype == "gitcommit"
						-- luacheck: pop
					end,
					---@module 'blink-cmp-conventional-commits'
					---@type blink-cmp-conventional-commits.Options
					opts = {
						-- See Configuration section below for available options
					},
				},
				calc = {
					name = "Calc",
					module = "blink-calc",
					opts = {
						show_equation = true, -- offer an extra "expr = result" item when typing '='
						show_bases = false, -- offer hex/binary items for integer results
						group_digits = false, -- offer a digit-grouped item; true uses ',' or pass a custom separator
						precision = 2, -- decimal places used to tame floating-point noise
						separator = " = ", -- text between expression and result in the equation item
					},
				},
				dictionary = {
					name = "blink-cmp-words",
					module = "blink-cmp-words.dictionary",
					-- All available options
					opts = {
						-- The number of characters required to trigger completion.
						-- Set this higher if completion is slow, 3 is default.
						dictionary_search_threshold = 3,

						-- See above
						score_offset = 0,

						-- See above
						definition_pointers = { "!", "&", "^" },
					},
				},
				emoji = {
					module = "blink-emoji",
					name = "Emoji",
					score_offset = 15, -- Tune by preference
					opts = {
						insert = true, -- Insert emoji (default) or complete its name
						---@type string|table|fun():table
						trigger = function()
							return { ":" }
						end,
					},
				},
				snippets = {
					module = "blink.cmp.sources.snippets",
					score_offset = -1,
					-- For `snippets.preset == 'luasnip'`
					opts = {
						-- Whether to use show_condition for filtering snippets
						use_show_condition = true,
						-- Whether to show autosnippets in the completion list
						show_autosnippets = true,
					},
				},
				thesaurus = {
					name = "blink-cmp-words",
					module = "blink-cmp-words.thesaurus",
					-- All available options
					opts = {
						-- A score offset applied to returned items.
						-- By default the highest score is 0 (item 1 has a score of -1, item 2 of -2 etc..).
						score_offset = 0,

						-- Default pointers define the lexical relations listed under each definition,
						-- see Pointer Symbols below.
						-- Default is as below ("antonyms", "similar to" and "also see").
						definition_pointers = { "!", "&", "^" },

						-- The pointers that are considered similar words when using the thesaurus,
						-- see Pointer Symbols below.
						-- Default is as below ("similar to", "also see" }
						similarity_pointers = { "&", "^" },

						-- The depth of similar words to recurse when collecting synonyms. 1 is similar words,
						-- 2 is similar words of similar words, etc. Increasing this may slow results.
						similarity_depth = 2,
					},
				},
			},
		},
	},
}
