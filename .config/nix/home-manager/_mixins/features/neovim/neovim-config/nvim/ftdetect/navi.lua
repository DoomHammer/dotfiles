-- luacheck: push ignore 113
vim.api.nvim_create_augroup("FileTypeDetect", { clear = true })

vim.api.nvim_create_autocmd({ "BufNew", "BufNewFile", "BufRead" }, {
	pattern = "*.cheat",
	callback = function()
		-- luacheck: push ignore 112
		vim.opt.filetype = "navi"
		-- luacheck: pop
	end,
	group = "FileTypeDetect",
})
-- luacheck: pop
