lvim.transparent_window = false
vim.g.neovide_cursor_animation_length = 0.01
vim.g.neovide_cursor_trail_length = 0.1
vim.g.neovide_floating_opacity = 0.8
vim.g.neovide_transparency = 0.8
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  command = "hi BufferLineFill guifg=None guibg=None|hi BufferLineTabClose guifg=#616e88 guibg=None"
})
