-- Vim
vim.g.tokyonight_style = 'storm'
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.guifont = 'Fira Code:h12'
vim.g.python3_host_prog = "/Users/gustavkristensen/opt/anaconda3/bin/python"
vim.o.foldminlines = 5
vim.o.foldlevel = 3
vim.o.cc = "80"
vim.o.relativenumber = true
vim.opt.termguicolors = true

local status_ok, ui_overrider = pcall(require, "popui.ui-overrider")

if not status_ok then
  return
end

vim.ui.select = require"popui.ui-overrider"
