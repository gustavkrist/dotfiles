vim.lsp.config("ctags_lsp", {
  cmd = { "ctags-lsp", "--ctags-bin=/opt/homebrew/bin/ctags", "--languages=coq" },
  filetypes = { "coq" },
  root_markers = { ".git" },
})
