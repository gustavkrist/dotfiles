local cmd
if require("util.os").is_macos() then
  cmd = { "ctags-lsp", "--ctags-bin=/opt/homebrew/bin/ctags", "--languages=coq" } else
  cmd = { "ctags-lsp", "--languages=coq" }
end
vim.lsp.config("ctags_lsp", {
  cmd = cmd,
  filetypes = { "coq" },
  root_markers = { ".git" },
})
