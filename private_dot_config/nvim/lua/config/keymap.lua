local opts = { noremap = true, silent = true }

local term_opts = { silent = true }
local has = require("util.plugins").has

-- Shorten function name
local map = vim.keymap.set

--Remap space as leader key
vim.keymap.set("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
map("n", "<leader><leader>", "<C-^>", { desc = "Go to last used buffer", silent = true })
map("n", "<leader>c", "<cmd>lua require('util.bufferline').buf_kill()<cr>", { desc = "Close Buffer", silent = true })
map("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "No Highlight", silent = true })
map("n", "<leader>m", "<cmd>messages<cr>", { desc = "Show messages", silent = true })
map("n", "<C-i>", "<C-i>", { noremap = true, silent = true })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Remap for dealing with word wrap
map("n", "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Basic normal mode navigation
map("n", "L", "$", opts)
map("n", "H", "^", opts)

-- Resize with arrows
map("n", "<C-Down>", ":resize +2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)
map("n", "<C-Up>", ":resize -2<CR>", opts)

-- Navigate buffers
map("n", "<Tab>", "<cmd>execute 'bnext ' . max([v:count, 1])<CR>", opts)
map("n", "<S-Tab>", "<cmd>execute 'bprevious ' . max([v:count, 1])<CR>", opts)
map("n", "]b", "<cmd>execute 'bnext ' . max([v:count, 1])<CR>", opts)
map("n", "[b", "<cmd>execute 'bprevious ' . max([v:count, 1])<CR>", opts)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Quickfix
map("n", "[q", "<cmd>cprev<cr>zz", { desc = "Previous Quickfix" })
map("n", "]q", "<cmd>cnext<cr>zz", { desc = "Next Quickfix" })
map(
  "n",
  "<leader>qa",
  "<cmd>caddexpr expand('%') .. ':' .. line('.') ..  ':' .. getline('.')<cr>",
  { desc = "Add to quickfix list" }
)
map("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- tabs
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })

-- Insert --
-- Press jk fast to enter
map("i", "jk", "<ESC>", opts)
map("i", "<C-l>", "<Right>", opts)

-- Visual --
-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Terminal --
-- Better terminal navigation
map("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
map("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
map("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
map("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- LSP
map("n", "gl", function()
  local float = vim.diagnostic.config().float
  if float then
    local config = type(float) == "table" and float or {}
    config.scope = "line"

    vim.diagnostic.open_float(config)
  end
end, { noremap = true, silent = true, desc = "Show line diagnostics" })
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
map(
  "n",
  "<leader>la",
  "<cmd>lua vim.lsp.buf.code_action()<cr>",
  { desc = "Code Action", silent = true, noremap = true }
)
map("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "Info", silent = true, noremap = true })
map(
  "n",
  "<leader>lj",
  "<cmd>lua vim.diagnostic.goto_next()<CR>",
  { desc = "Next Diagnostic", silent = true, noremap = true }
)
map(
  "n",
  "<leader>lk",
  "<cmd>lua vim.diagnostic.goto_prev()<cr>",
  { desc = "Prev Diagnostic", silent = true, noremap = true }
)
map(
  "n",
  "<leader>ll",
  "<cmd>lua vim.lsp.codelens.run()<cr>",
  { desc = "CodeLens Action", silent = true, noremap = true }
)
map(
  "n",
  "<leader>lq",
  "<cmd>lua vim.diagnostic.set_loclist()<cr>",
  { desc = "Quickfix", silent = true, noremap = true }
)
map("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename", silent = true, noremap = true })

-- Commenting
map("n", "<leader>/", "gcc", { desc = "Toggle Comment", silent = true, remap = true })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("v", "<leader>/", "gc", { desc = "Toggle Comment", silent = true, remap = true })

if vim.g.started_by_firenvim == nil and vim.g.vscode == nil then
  require("util.wezterm").setup()
end
