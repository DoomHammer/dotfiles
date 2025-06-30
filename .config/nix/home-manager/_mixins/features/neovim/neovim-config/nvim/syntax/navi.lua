-- luacheck: push ignore 113
vim.cmd([[
  syntax match Comment "\v^;.*$"
  syntax match Statement "\v^\%.*$"
  syntax match Operator "\v^\#.*$"
  syntax match String "\v\<.*\>"
  syntax match String "\v^\$.*$"
]])
-- luacheck: pop
