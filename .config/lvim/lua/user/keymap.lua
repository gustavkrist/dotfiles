lvim.leader = "space"
lvim.keys.normal_mode = {
  ["<C-s>"] = ":w<cr>",

  -- Navigate Buffers
  ["<Tab>"] = ":bnext<CR>",
  ["<S-Tab>"] = ":bprevious<CR>",
  ["gh"] = ":lua vim.lsp.buf.hover()<CR>",
  ["gl"] = ":lua vim.diagnostic.open_float()<CR>"
}
lvim.keys.insert_mode = {
  ["<C-l>"] = "<Right>",
  ["<C-_>"] = "<End>",
  ["<C-b>"] = "<C-x><C-o>",
}

lvim.builtin.which_key.mappings["o"] = { "<cmd>Obsession<CR>", "Obsession" }
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
}

vim.api.nvim_set_keymap('i', '<C-^>', 'pumvisible() ? "<C-e><CR>" : "<CR>"', { noremap = true, silent = true, expr = true })

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
  },
  -- for normal mode
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}

local status_cmp_ok, cmp = pcall(require, "cmp")
if not status_cmp_ok then
  return
end
local status_luasnip_ok, luasnip = pcall(require, "luasnip")
if not status_luasnip_ok then
  return
end

local jumpable = require('lvim.core.cmp').methods.jumpable
local luasnip = require("luasnip")
local check_backspace = require('lvim.core.cmp').methods.check_backspace
local is_emmet_active = require("lvim.core.cmp").methods.is_emmet_active

lvim.builtin.cmp.mapping = cmp.mapping.preset.insert {
  ["<C-k>"] = cmp.mapping.select_prev_item(),
  ["<C-j>"] = cmp.mapping.select_next_item(),
  ["<C-d>"] = cmp.mapping.scroll_docs(-4),
  ["<C-f>"] = cmp.mapping.scroll_docs(4),
  -- TODO: potentially fix emmet nonsense
  ["<Tab>"] = cmp.mapping(function(fallback)
    if luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    elseif cmp.visible() then
      cmp.select_next_item()
    elseif check_backspace() then
      fallback()
    elseif is_emmet_active() then
      return vim.fn["cmp#complete"]()
    else
      fallback()
    end
  end, {
    "i",
    "s",
  }),
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if luasnip.jumpable(-1) then
      luasnip.jump(-1)
    elseif cmp.visible() then
      cmp.select_prev_item()
    else
      fallback()
    end
  end, {
    "i",
    "s",
  }),
  ["<C-Space>"] = cmp.mapping.complete(),
  ["<C-e>"] = cmp.mapping.abort(),
  ["<CR>"] = cmp.mapping(function(fallback)
    if cmp.visible() and cmp.confirm(lvim.builtin.cmp.confirm_opts) then
      if jumpable() then
        luasnip.jump(1)
      end
      return
    end

    if jumpable() then
      if not luasnip.jump(1) then
        fallback()
      end
    else
      fallback()
    end
  end),
}
