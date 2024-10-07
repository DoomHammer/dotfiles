-- Borrowed from https://github.com/bondzula/nvim/blob/e089fc676c42acb18255fb3432c998d647eae840/lua/plugins/languages/lua.lua
return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, options)
			vim.list_extend(options.ensure_installed, { "lua", "luadoc" })
		end,
	},

	{
		"williamboman/mason.nvim",
		opts = function(_, options)
			vim.list_extend(options.ensure_lsp_installed, { "lua_ls" })
			vim.list_extend(options.ensure_tools_installed, { "stylua", "luacheck" })
		end,
	},

	{
		"neovim/nvim-lspconfig",
		opts = function(_, options)
			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							codeLens = {
								enable = true,
							},
							completion = {
								callSnippet = "Replace",
							},
							doc = {
								privateName = { "^_" },
							},
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
						},
					},
				},
			}

			options.servers = vim.tbl_deep_extend("force", options.servers, servers)
		end,
	},

	{
		"mfussenegger/nvim-lint",
		opts = function(_, options)
			local linters_by_ft = {
				lua = { "luacheck" },
			}

			options.linters_by_ft = vim.tbl_deep_extend("force", options.linters_by_ft, linters_by_ft)
		end,
	},

	{
		"stevearc/conform.nvim",
		opts = function(_, options)
			local formatters_by_ft = {
				lua = { "stylua" },
			}

			options.formatters_by_ft = vim.tbl_deep_extend("force", options.formatters_by_ft, formatters_by_ft)
		end,
	},
}
