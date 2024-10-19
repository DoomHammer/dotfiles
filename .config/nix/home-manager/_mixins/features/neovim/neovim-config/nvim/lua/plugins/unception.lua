return {
	-- Allow `git commit` inside NeoVim terminal
	"samjwill/nvim-unception",
	init = function()
		-- luacheck: push ignore 112
		vim.g.unception_open_buffer_in_new_tab = true
		-- luacheck: pop
	end,
}
