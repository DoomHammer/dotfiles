vim.api.nvim_create_autocmd("FileType", {
	pattern = { "hcl", "terraform" },
	desc = "terraform/hcl commentstring configuration",
	command = "setlocal commentstring=#\\ %s",
})

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, {
					"terraform",
					"hcl",
				})
			end
			return opts
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = function(_, options)
			vim.list_extend(options.ensure_lsp_installed, { "terraformls" })
			vim.list_extend(options.ensure_tools_installed, { "tflint" })
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				terraformls = {},
			},
		},
	},
	{
		"nvimtools/none-ls.nvim",
		optional = true,
		opts = function(_, opts)
			local null_ls = require("null-ls")
			opts.sources = vim.list_extend(opts.sources or {}, {
				null_ls.builtins.formatting.terraform_fmt,
				null_ls.builtins.diagnostics.terraform_validate,
			})
			return opts
		end,
	},
	{
		"mfussenegger/nvim-lint",
		optional = true,
		opts = {
			linters_by_ft = {
				terraform = { "terraform_validate" },
				tf = { "terraform_validate" },
			},
		},
	},
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				terraform = { "terraform_fmt" },
				tf = { "terraform_fmt" },
				["terraform-vars"] = { "terraform_fmt" },
			},
		},
	},
	{
		"ANGkeith/telescope-terraform-doc.nvim",
		ft = "terraform",
		dependencies = "telescope.nvim",
		config = function()
			require("telescope").load_extension("terraform_doc")
		end,
	},
}
