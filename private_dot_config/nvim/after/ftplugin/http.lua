vim.keymap.set("n", "<CR>", require("kulala").run, { buffer = 0, desc = "Execute current request" })
vim.keymap.set("n", "[[", require("kulala").jump_prev, { buffer = 0, desc = "Jump to previous request" })
vim.keymap.set("n", "]]", require("kulala").jump_next, { buffer = 0, desc = "Jump to next request" })
vim.keymap.set("n", "<localleader>i", require("kulala").inspect, { buffer = 0, desc = "Inspect current request" })
vim.keymap.set(
  "n",
  "<localleader>t",
  require("kulala").toggle_view,
  { buffer = 0, desc = "Toggle between body and headers" }
)
vim.keymap.set("n", "<localleader>c", require("kulala").copy, { buffer = 0, desc = "Copy request as curl command" })
vim.keymap.set(
  "n",
  "<localleader>p",
  require("kulala").from_curl,
  { buffer = 0, desc = "Paste curl request from clipboard as http" }
)
