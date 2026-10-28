vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.lsp.semantic_tokens.enable(false, { bufnr = 0 })
vim.api.nvim_buf_set_keymap(0, 'i', "'", "'", {})
