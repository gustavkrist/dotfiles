local M = {}

M.config = function()
  vim.g.R_app = 'radian'
  vim.g.R_cmd = 'R'
  vim.g.R_hl_term = 0
  vim.g.R_bracketed_paste = 1
  vim.g.R_assign = 2
  vim.g.Rout_more_colors = 1
  vim.g.rrst_syn_hl_chunk = 1
  vim.g.rmd_syn_hl_chunk = 1
  vim.g.rout_follow_colorscheme = 1
  vim.g.R_openpdf = 1
end

return M
