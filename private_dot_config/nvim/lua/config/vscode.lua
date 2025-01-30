vscode = require("vscode")
vim.g.clipboard = vim.g.vscode_clipboard
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.smartindent = true

--- Increase or decrease editor size
---@param count integer
---@param increase boolean
local function manage_editor_size(count, increase)
  for i = 1, count do
    vscode.call(increase and "workbench.action.increaseViewSize" or "workbench.action.decreaseViewSize")
  end
end

local function open_whichkey_in_visual_mode()
  vim.cmd("normal! gv")
  local visualmode = vim.fn.visualmode()
  if visualmode == "V" then
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    vscode.call("whichkey.show", { range = { start_line, end_line } })
  else
    local start_pos = vim.fn.getpos("v")
    local end_pos = vim.fn.getpos(".")
    vscode.call("whichkey.show", { range = { start_pos[2], start_pos[3], end_pos[2], end_pos[3] } })
  end
end

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Split navigation
map({ "n", "x" }, "<C-j>", function()
  vscode.call("workbench.action.navigateDown")
end, opts)
map({ "n", "x" }, "<C-k>", function()
  vscode.call("workbench.action.navigateUp")
end, opts)
map({ "n", "x" }, "<C-h>", function()
  vscode.call("workbench.action.navigateLeft")
end, opts)
map({ "n", "x" }, "<C-l>", function()
  vscode.call("workbench.action.navigateRight")
end, opts)

map("n", "<C-w>_", function()
  vscode.call("workbench.action.toggleEditorWidths")
end, opts)
map("n", "<Space>", function()
  vscode.call("whichkey.show")
end, opts)
map("x", "<Space>", open_whichkey_in_visual_mode, opts)
map("n", "<Esc>", "<cmd>nohlsearch<cr>", opts)

-- Same tab behavior as in VSCode
map("n", "<Tab>", "<cmd>Tabnext<cr>", opts)
map("n", "<S-Tab>", "<cmd>Tabprev<cr>", opts)

-- Remap for dealing with word wrap
map("n", "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Basic normal mode navigation
map("n", "L", "$", opts)
map("n", "H", "^", opts)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Visual --
-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- LSP
map(
  "n",
  "gs",
  "<cmd>lua vim.lsp.buf.signature_help()<cr>",
  { noremap = true, silent = true, desc = "Show Signature Help" }
)
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { noremap = true, silent = true, desc = "Goto Declaration" })
map("n", "gh", "<cmd>lua vim.lsp.buf.hover()<cr>", { noremap = true, silent = true })
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { noremap = true, silent = true, desc = "Goto Definition" })
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { noremap = true, silent = true, desc = "Goto References" })
map("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { noremap = true, silent = true })
map(
  "n",
  "gI",
  "<cmd>lua vim.lsp.buf.implementation()<cr>",
  { noremap = true, silent = true, desc = "Goto Implementation" }
)

-- Commenting
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })

-- Toggle terminal
map("n", "<C-t>", function()
  vscode.call("workbench.action.terminal.toggleTerminal")
end, opts)

-- Insert snippet in visual mode
map("x", "<Tab>", function()
  vscode.with_insert(function()
    vscode.action("editor.action.insertSnippet")
  end)
end)
