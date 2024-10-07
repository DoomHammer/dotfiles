-- Borrowed from https://github.com/bondzula/nvim/blob/e089fc676c42acb18255fb3432c998d647eae840/lua/plugins/languages/lua.lua
return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, options)
			vim.list_extend(options.ensure_installed, { "nix" })
		end,
	},

	{
		"williamboman/mason.nvim",
		opts = function(_, options)
			vim.list_extend(options.ensure_lsp_installed, { "nil_ls" })
		end,
	},

	{
		"mfussenegger/nvim-lint",
		opts = function(_, options)
			local linters_by_ft = {
				nix = { "statix", "deadnix" },
			}

			options.linters_by_ft = vim.tbl_deep_extend("force", options.linters_by_ft, linters_by_ft)
		end,
	},

	{
		"stevearc/conform.nvim",
		opts = function(_, options)
			local formatters = {
				nix = { "nixfmt" },
			}

			options.formatters = vim.tbl_deep_extend("force", options.formatters, formatters)
		end,
	},
}
