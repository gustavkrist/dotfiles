local M = {}

M.setup = function()
  local status_ok, indent_blankline = pcall(require, "indent_blankline")

  if not status_ok then
    return
  end

  vim.g.indentLine_enabled = 1
  vim.g.indent_blankline_char = "▏"
  vim.g.indent_blankline_filetype_exclude = { "help", "terminal", "alpha" }
  vim.g.indent_blankline_buftype_exclude = { "terminal" }
  vim.g.indent_blankline_show_trailing_blankline_indent = false
  vim.g.indent_blankline_show_first_indent_level = false
end

return M
