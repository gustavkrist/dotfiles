local M = {}

---@param delim string
function M.add_cell_below(delim)
	vim.fn["slime_cells#go_to_next_cell"]()
	local line_count = vim.api.nvim_buf_line_count(0)
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	if current_line == line_count then
		vim.api.nvim_buf_set_lines(0, line_count, line_count, false, { delim, "" })
		vim.api.nvim_feedkeys("Gi", "n", false)
	else
		vim.api.nvim_buf_set_lines(0, current_line - 2, current_line - 2, false, { delim, "" })
		vim.api.nvim_feedkeys("kki", "n", false)
	end
end

---@param delim string
function M.add_cell_above(delim)
	vim.fn["slime_cells#go_to_previous_cell"]()
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local keys
  if current_line == 1 then
    current_line = current_line == 1 and 0 or current_line
    keys = "ki"
  else
    keys = "2ji"
  end
  vim.api.nvim_buf_set_lines(0, current_line, current_line, false, { delim, "" })
  vim.api.nvim_feedkeys(keys, "n", false)
end

return M
