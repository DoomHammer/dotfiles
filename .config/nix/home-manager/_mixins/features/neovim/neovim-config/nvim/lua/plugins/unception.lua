return {
  -- Allow `git commit` inside NeoVim terminal
  "samjwill/nvim-unception",
  init = function()
    vim.g.unception_open_buffer_in_new_tab = true
  end,
}
