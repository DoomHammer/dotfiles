return {
  {
    "rolv-apneseth/tfm.nvim",
    config = function()
      -- Set keymap so you can open the default terminal file manager (yazi)
      vim.api.nvim_set_keymap("n", "<leader>r", "", {
        noremap = true,
        callback = require("tfm").open,
        desc = "Open TFM",
      })
    end,
  },
}
