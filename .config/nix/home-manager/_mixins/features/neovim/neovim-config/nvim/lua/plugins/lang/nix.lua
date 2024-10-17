return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        nix = { "statix", "deadnix" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    -- opts will be merged with the parent spec
    opts = {
      formatters_by_ft = {
        nix = { "nix_fmt", "nixfmt", stop_after_first = true },
      },
      formatters = {
        nix_fmt = {
          command = "nix fmt",
        },
      },
    },
  },
}
