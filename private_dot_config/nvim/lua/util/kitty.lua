-- Credit https://github.com/MunsMan/kitty-navigator.nvim
local M = {}

local mappings = { h = "left", j = "bottom", k = "top", l = "right" }

M.navigate = function(direction)
  local left_win = vim.fn.winnr("1" .. direction)
  if vim.fn.winnr() ~= left_win then
    vim.api.nvim_command("wincmd " .. direction)
  else
    local command = {"kitty", "@", "kitten", "neighboring_window.py", mappings[direction]}
    vim.system(command)
  end
end

M.setup = function()
  vim.keymap.set("n", "<C-h>", function() M.navigate("h") end)
  vim.keymap.set("n", "<C-l>", function() M.navigate("l") end)
  vim.keymap.set("n", "<C-k>", function() M.navigate("k") end)
  vim.keymap.set("n", "<C-j>", function() M.navigate("j") end)
end

return M
