local pythonpath
if require("util.os").is_macos() then
  local conda = os.getenv("CONDA_PREFIX") or (os.getenv("HOME") .. "/mambaforge")
  pythonpath = conda .. "/bin/python"
else
  pythonpath = "python"
end
vim.opt.formatoptions:append("r")

if require("util.plugins").has("vim-slime") then
  vim.b.slime_cell_delimiter = "^#%%"
  vim.keymap.set(
    "n",
    "<localleader><cr>",
    "<Plug>SlimeCellsSendAndGoToNext",
    { desc = "Send cell and go next", buffer = 0 }
  )
  vim.keymap.set("n", "<localleader>j", "<Plug>SlimeCellsNext", { desc = "Next cell", buffer = 0 })
  vim.keymap.set("n", "<localleader>k", "<Plug>SlimeCellsPrev", { desc = "Prev cell", buffer = 0 })
  vim.keymap.set("n", "<localleader> ", "<Plug>SlimeLineSend", { desc = "Send line", buffer = 0 })
  vim.keymap.set(
    "n",
    "<localleader><localleader>",
    "<Plug>SlimeLineSend<cr>",
    { desc = "Send line and go next", buffer = 0 }
  )
  vim.keymap.set("x", "<localleader><cr>", "<Plug>SlimeRegionSend", { desc = "Send selection", buffer = 0 })
  vim.keymap.set("n", "<localleader>s", "<Plug>SlimeMotionSend", { desc = "Send motion", buffer = 0 })
  vim.keymap.set("n", "<localleader>c", "<Plug>SlimeConfig", { desc = "Vim-slime config", buffer = 0 })
  vim.keymap.set("n", "<localleader>o", function()
    require("util.vim-slime").add_cell_below("#%%")
  end, { desc = "New cell below", buffer = 0 })
  vim.keymap.set("n", "<localleader>O", function()
    require("util.vim-slime").add_cell_above("#%%")
  end, { desc = "New cell above", buffer = 0 })
end
