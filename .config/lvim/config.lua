--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- Faster clipboard for wsl
if vim.fn.has "wsl" == 1 then
  vim.g.clipboard = {
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
  }
end

-- general
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "onedarker"
vim.g.tokyonight_style = 'storm'
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.guifont = 'MesloLGS NF:h14'
vim.g.python3_host_prog = "/Users/gustavkristensen/opt/anaconda3/bin/python"
vim.o.foldminlines = 5
vim.o.foldlevel = 3
vim.o.cc = "80"
vim.o.relativenumber = true
-- lvim.transparent_window = true
vim.opt.termguicolors = false

-- Italic
vim.cmd([[
  set t_ZH=^[[3
  set t_ZR=^[[23m
]])

-- Folding

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
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
vim.cmd("vnoremap <C-s> :lua require('to_sage').to_sage()<CR>")

-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = ""
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }


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

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 0

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight = {
  enable = true,
  -- disable = { "latex" }
}
lvim.builtin.treesitter.indent = {
  enable = true,
  disable = { 'python' }
}

-- generic LSP settings


-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheRest` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
local opts = {
  on_attach = function(client, bufnr)
    require "lsp_signature".on_attach()
  end
} -- check the lspconfig documentation for a list of all possible options
require("lvim.lsp.manager").setup("jedi_language_server", opts)


lvim.lsp.diagnostics.virtual_text = false

-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end
-- you can overwrite the null_ls setup table (useful for setting the root_dir function)
-- lvim.lsp.null_ls.setup = {
--   root_dir = require("lspconfig").util.root_pattern("Makefile", ".git", "node_modules"),
-- }
-- or if you need something more advanced
-- lvim.lsp.null_ls.setup.root_dir = function(fname)
--   if vim.bo.filetype == "javascript" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "node_modules")(fname)
--       or require("lspconfig/util").path.dirname(fname)
--   elseif vim.bo.filetype == "php" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "composer.json")(fname) or vim.fn.getcwd()
--   else
--     return require("lspconfig/util").root_pattern("Makefile", ".git")(fname) or require("lspconfig/util").path.dirname(fname)
--   end
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "black", filetypes = { "python" } },
  --   { exe = "isort", filetypes = { "python" } },
  --   {
  --     exe = "prettier",
  --     ---@usage arguments to pass to the formatter
  --     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
  --     args = { "--print-with", "100" },
  --     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
  --     filetypes = { "typescript", "typescriptreact" },
  --   },
}

-- -- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "flake8", filetypes = { "python" } },
  --  {
  --    exe = "shellcheck",
  ---@usage arguments to pass to the formatter
  -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
  --    args = { "--ignore=E501"} -- "--severity", "warning" },
  --  }
  --   {
  --     exe = "codespell",
  --     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
  --     filetypes = { "javascript", "python" },
  --   },
}

-- Debugging
lvim.builtin.dap.active = true

-- Additional Plugins
lvim.plugins = {
  {
    'lervag/vimtex',
    ft = { "latex", "tex" }
  },
  { 'sainnhe/edge' },
  { 'joshdick/onedark.vim' },
  { 'arcticicestudio/nord-vim' },
  -- { 'folke/tokyonight.nvim' },
  -- { 'dracula/vim' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-repeat' },
  { 'christoomey/vim-tmux-navigator' },
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require('neoscroll').setup({
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
          '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = true, -- Hide cursor while scrolling
        stop_eof = true, -- Stop at <EOF> when scrolling downwards
        use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
        respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = nil, -- Default easing function
        pre_hook = nil, -- Function to run before the scrolling animation starts
        post_hook = nil, -- Function to run after the scrolling animation ends
      })
    end
  },
  {
    "tzachar/cmp-tabnine",
    run = "./install.sh",
    requires = "hrsh7th/nvim-cmp",
    event = "InsertEnter",
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function()
      require "lsp_signature".setup()
    end
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    setup = function()
      vim.g.indentLine_enabled = 1
      vim.g.indent_blankline_char = "▏"
      vim.g.indent_blankline_filetype_exclude = { "help", "terminal", "alpha" }
      vim.g.indent_blankline_buftype_exclude = { "terminal" }
      vim.g.indent_blankline_show_trailing_blankline_indent = false
      vim.g.indent_blankline_show_first_indent_level = false
    end
  },
  {
    "ethanholz/nvim-lastplace",
    event = "BufRead",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = {
          "gitcommit", "gitrebase", "svn", "hgcommit",
        },
        lastplace_open_folds = true,
      })
    end,
  },
  {
    "felipec/vim-sanegx",
    event = "BufRead",
  },
  {
    'tpope/vim-obsession',
    cmd = "Obsession"
  },
  {
    'dbakker/vim-paragraph-motion'
  },
  {
    'michaeljsmith/vim-indent-object'
  },
  {
    'justinmk/vim-sneak'
  },
  {
    'rebelot/kanagawa.nvim'
  },
  {
    'vim-pandoc/vim-pandoc',
    requires = 'vim-pandoc/vim-pandoc-syntax',
    ft = "markdown"
  },
  -- {
  --   'chrisbra/NrrwRgn',
  --   event = "BufWinEnter",
  -- },
  {
    'coachshea/vim-textobj-markdown',
    requires = 'kana/vim-textobj-user',
    ft = { "markdown", "Rmd" }
  },
  -- {
  --   'hkupty/iron.nvim',
  --   event = "BufWinEnter"
  -- },
  {
    'urbainvaes/vim-ripple',
    event = "BufWinEnter"
  },
  {
    'jamespeapen/Nvim-R',
    ft = { "Rmd", "R" }
  },
  {
    'edkolev/tmuxline.vim',
    event = "BufWinEnter"
  },
  {
    'wakatime/vim-wakatime',
    event = "BufWinEnter"
  },
  {
    "folke/lsp-colors.nvim",
    event = "BufRead",
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "*" }, {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      })
    end,
    event = "BufWinEnter",
  },
  {
    "rmagatti/goto-preview",
    config = function()
      require('goto-preview').setup {
        width = 120; -- Width of the floating window
        height = 25; -- Height of the floating window
        default_mappings = false; -- Bind default mappings
        debug = false; -- Print debug information
        opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
        post_open_hook = nil -- A function taking two arguments, a buffer and a window to be ran as a hook.
        -- You can use "default_mappings = true" setup option
        -- Or explicitly set keybindings
        -- vim.cmd("nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>")
        -- vim.cmd("nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
        -- vim.cmd("nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>")
      }
    end,
    event = "BufWinEnter",
  },
  {
    "Pocco81/AutoSave.nvim",
    config = function()
      require("autosave").setup({
        conditions = {
          filename_is_not = { "config.lua" }
        }
      })
    end,
  },
  {
    "monaqa/dial.nvim",
    event = "BufWinEnter",
    config = function()
      local augend = require("dial.augend")
      vim.cmd [[
          nmap <C-a> <Plug>(dial-increment)
          nmap <C-x> <Plug>(dial-decrement)
          vmap <C-a> <Plug>(dial-increment)
          vmap <C-x> <Plug>(dial-decrement)
          vmap g<C-a> <Plug>(dial-increment-additional)
          vmap g<C-x> <Plug>(dial-decrement-additional)
        ]]
      require("dial.config").augends:register_group {
        default = {
          augend.constant.new {
            elements = { "and", "or" },
            word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
            cyclic = true, -- "or" is incremented into "and".
          },
          augend.constant.new {
            elements = { "&&", "||" },
            word = false,
            cyclic = true,
          },
          augend.constant.new {
            elements = { "true", "false" },
            word = true,
            cyclic = true
          },
          augend.constant.new {
            elements = { "True", "False" },
            word = true,
            cyclic = true
          }
        },
      }
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },
  {
    'simrat39/rust-tools.nvim',
    config = function()
      require("rust-tools").setup({
        hover_actions = {
          auto_focus = true,
        }
      })
      vim.cmd("nnoremap <C-_> <cmd>RustRun<CR>")
    end,
    ft = "rust"
  }
}
-- require('neoscroll').setup()

-- vim.cmd("setlocal syntax=tex")
-- vim.cmd("setlocal conceallevel=2")
-- vim.cmd("colorscheme edge")
-- Autocommands (https://neovim.io/doc/user/autocmd.html)
lvim.autocommands.custom_groups = {
  { "BufWinEnter", "*", "highlight TSComment cterm=italic gui=italic" },
  { "BufAdd", "*.tex", "setlocal syntax=tex | setlocal conceallevel=2" },
  { "BufEnter", "*.tex", "setlocal conceallevel=2 | setlocal syntax=tex | colorscheme edge | hi! link IndentBlanklineChar Comment | hi! clear Conceal" },
  { "BufHidden", "*.tex", "colorscheme onedarker" },
  { "BufWinEnter", "*.Rmd", "nmap <buffer>  \\cd|nmap <buffer> <C-CR> \\cd|inoremap <M-Tab> ```{r}<CR><CR>```<UP>|inoremap <C-Tab> ```{r}<CR><CR>```<UP>" },
  { "VimLeave", "*", "if exists('g:SendCmdToR') && string(g:SendCmdToR) != 'function(''SendCmdToR_fake'')' | call RQuit('nosave') | endif" },
  { "BufWritePost", "*.Rmd", "execute \"normal \\<plug>RMakeRmd(\\\"pdf_document\\\")\"" },
}


vim.g.vimtex_view_method = 'skim'

if vim.loop.os_uname().sysname == "Linux" then
  vim.g.vimtex_view_method = "general"
  vim.g.vimtex_view_general_viewer = "sumatrapdf"
  vim.g.R_pdfviewer = "zathura"
elseif vim.loop.os_uname().sysname == "Darwin" then
  vim.g.vimtex_view_method = "skim"
end

-- Cmp
lvim.builtin.cmp.confirm_opts = {
  select = false
}

vim.api.nvim_set_keymap('i', '<C-^>', 'pumvisible() ? "<C-e><CR>" : "<CR>"', { noremap = true, silent = true, expr = true })

-- NeoVide

vim.g.neovide_cursor_animation_length = 0.01
vim.g.neovide_cursor_trail_length = 0.1
vim.g.neovide_floating_opacity = 0.8

-- Send to REPL

vim.cmd(
  [[
let g:ripple_repls = {}
let g:ripple_repls["rmarkdown"] = "radian"
]]
)
vim.g.ripple_winpos = "split"

-- lvim.builtin.terminal.direction = "horizontal"
-- lvim.builtin.terminal.size = 12

-- R and RMD

vim.g.R_app = 'radian'
vim.g.R_cmd = 'R'
vim.g.R_hl_term = 0
vim.g.R_bracketed_paste = 1
vim.g.R_assign = 2
vim.g.Rout_more_colors = 1
vim.g.rrst_syn_hl_chunk = 1
vim.g.rmd_syn_hl_chunk = 1
vim.g.rout_follow_colorscheme = 1
vim.g.R_openpdf = 1

-- Snippets

require('luasnip').filetype_extend("rmd", { "tex" })


-- CMP Tab behaviour

local status_cmp_ok, cmp = pcall(require, "cmp")
if not status_cmp_ok then
  return
end
local status_luasnip_ok, luasnip = pcall(require, "luasnip")
if not status_luasnip_ok then
  return
end

local jumpable = require('lvim.core.cmp').methods.jumpable
local check_backspace = require('lvim.core.cmp').methods.check_backspace
local is_emmet_active = require("lvim.core.cmp").methods.is_emmet_active


lvim.builtin.cmp.mapping = cmp.mapping.preset.insert {
  ["<C-k>"] = cmp.mapping.select_prev_item(),
  ["<C-j>"] = cmp.mapping.select_next_item(),
  ["<C-d>"] = cmp.mapping.scroll_docs(-4),
  ["<C-f>"] = cmp.mapping.scroll_docs(4),
  -- TODO: potentially fix emmet nonsense
  ["<Tab>"] = cmp.mapping(function(fallback)
    if luasnip.expandable() then
      luasnip.expand()
    elseif jumpable() then
      luasnip.jump(1)
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
    if jumpable(-1) then
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
      else
        cmp.mapping.confirm({ select = false })
      end
      return
    end

    if jumpable() then
      if not luasnip.jump(1) then
        fallback()
      end
    elseif cmp.visible() then
      cmp.mapping.confirm({ select = false })
    else
      fallback()
    end
  end),
}

require("luasnip.loaders.from_vscode").lazy_load {
  paths = { "~/.local/share/lunarvim/site/pack/packer/start/friendly-snippets" }
}

-- package.path = package.path .. ";" .. os.getenv("LUNARVIM_CONFIG_DIR") .. "/packages/to_sage.lua"
-- require("to_sage")
