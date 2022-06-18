local M = {}

function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

M.buffer_to_string = function()
  local content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
  return table.concat(content, "\n")
end

M.replace_buffer = function(content)
  vim.api.nvim_buf_set_lines(0, 0, vim.api.nvim_buf_line_count(0), false, content)
end

M.admon_to_vim = function()
  local content = M.buffer_to_string()
  local fp = io.popen("python " .. os.getenv("LUNARVIM_CONFIG_DIR") .. "/scripts/admon_to_mkdocs.py >/tmp/admon_to_mkdocs", "w")
  fp:write(content)
  fp:close()
  local fp = io.open("/tmp/admon_to_mkdocs")
  local content = fp:read("*a")
  fp:close()
  M.replace_buffer(Split(content, "\n"))
end

M.admon_to_inkdrop = function()
  local content = M.buffer_to_string()
  local fp = io.popen("python " .. os.getenv("LUNARVIM_CONFIG_DIR") .. "/scripts/admon_to_inkdrop.py >/tmp/admon_to_inkdrop", "w")
  fp:write(content)
  fp:close()
  local fp = io.open("/tmp/admon_to_inkdrop")
  local content = fp:read("*a")
  fp:close()
  M.replace_buffer(Split(content, "\n"))
end

return M
