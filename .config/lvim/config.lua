require "user.keymap"
require "user.autocmds"
require "user.os"
require "user.plugins"
require "user.null_ls"
require "user.lsp"
require "user.treesitter"
require "user.options"
require "user.popup"

-- Italic
vim.cmd([[
  set t_ZH=^[[3
  set t_ZR=^[[23m
]])

-- Lvim
lvim.transparent_window = true
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "nord"

-- Cmp
lvim.builtin.cmp.confirm_opts = {
  select = false
}

-- Terminal
lvim.builtin.terminal.active = true

-- Bufferline
lvim.builtin.bufferline.active = true
lvim.builtin.bufferline.options.always_show_bufferline = true
lvim.builtin.bufferline.options.show_close_icon = true

-- NvimTree
lvim.builtin.nvimtree.setup.view.side = "left"
-- lvim.builtin.nvimtree.icons.git = {
--     unstaged = "✗",
--     staged = "✓",
--     unmerged = "",
--     renamed = "➜",
--     untracked = "★",
--     deleted = "",
-- }
lvim.builtin.nvimtree.setup.update_cwd = true
lvim.builtin.nvimtree.setup.update_focused_file.enable = true
lvim.builtin.nvimtree.setup.update_focused_file.update_cwd = true

-- Notify
lvim.builtin.notify.active = true

-- Dashboard
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"

-- Snippets

require('luasnip').filetype_extend("rmd", { "tex" })

if vim.g.neovide == true then
  require "user.neovide"
end
