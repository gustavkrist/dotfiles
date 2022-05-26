local M = {}

M.config = function()
  vim.cmd([[
  let g:ripple_repls = {}
  let g:ripple_repls["rmarkdown"] = "radian"
  ]]
  )
  vim.g.ripple_winpos = "split"
end

return M
