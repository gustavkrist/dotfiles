local M = {}

local function visual_selection_range()
  local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
  local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  if cecol > 200 then
    cecol = 200
  end
  if csrow < cerow or (csrow == cerow and cscol <= cecol) then
    return csrow - 1, cscol - 1, cerow, cecol
  else
    return cerow, cecol - 1, csrow - 1, cscol
  end
end

function split(str, pat)
   local t = {}
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(t, cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

-- see if the file exists
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function lines_from(file)
  if not file_exists(file) then return {} end
  local lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

function M.to_sage()
  local csrow, cscol, cerow, cecol = visual_selection_range()
  local buffer = vim.api.nvim_get_current_buf()
  local text = vim.api.nvim_buf_get_lines(buffer, csrow, cerow, true)
  for i=1, cerow-csrow do
    text[i] = string.sub(text[i], cscol, cecol)
  end
  local path = os.getenv("HOME") .. "/.local/share/sage/in.py"
  local sagefile = io.open(path, "w+")
  io.output(sagefile)
  io.write("from sage.all_cmdline import *\nimport os\n\n")
  io.write("def tex(s):\n\treturn f.write(latex(s) + '\\n')\n\n")
  io.write("path = os.getenv('HOME') + '/.local/share/sage/out.tex'\n")
  io.write("with open(path, 'w') as f:\n\t")
  io.write(table.concat(text, "\n\t"))
  io.close(sagefile)
  os.execute("sage $HOME/.local/share/sage/in.py")
  local path = string.sub(path, 1, -6) .. "out.tex"
  local tex = lines_from(path)
  vim.api.nvim_buf_set_lines(buffer, csrow, cerow, true, tex)
end

return M
