vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.keymap.set("n", "<localleader>p", "<cmd>TypstPreviewToggle<cr>", { buf = 0 })
vim.keymap.set("n", "<localleader>c", "<cmd>TypstPreviewFollowCursorToggle<cr>", { buf = 0 })
vim.bo.formatoptions = "jqonr"
