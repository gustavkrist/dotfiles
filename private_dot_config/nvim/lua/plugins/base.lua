return {
  {
    "folke/lazy.nvim",
    tag = "stable",
    vscode = true,
  },
  { "nvim-lua/plenary.nvim", vscode = true },
  {
    "tpope/vim-repeat",
    event = "User FileOpened",
    vscode = true,
  },
  {
    "folke/which-key.nvim",
    config = function(_, opts)
      local which_key = require("which-key")
      local mappings = {
        {
          mode = "n",
          { "<leader><Tab>", group = "Tabs" },
          { "<leader>a", group = "AI" },
          { "<leader>S", group = "Sessions" },
          { "<leader>g", group = "Git" },
          { "<leader>h", group = "Grapple" },
          { "<leader>l", group = "Lsp" },
          { "<leader>n", group = "Generate Annotations" },
          { "<leader>o", group = "Open in" },
          { "<leader>og", group = "Open in GitHub.." },
          { "<leader>q", group = "Quickfix" },
          { "<leader>s", group = "Search" },
          { "<leader>t", group = "Terminal" },
          { "<leader>u", group = "Toggles" },
        },
      }
      which_key.setup(opts)
      which_key.add(mappings)
    end,
    opts = {
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
          enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
          suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
          operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
          motions = true, -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = false, -- misc bindings to work with windows
          z = true, -- bindings for folds, spelling and others prefixed with z
          g = true, -- bindings for prefixed with g
        },
      },
      defaults = {
        delay = 100,
      },
      -- add operators that will trigger motion and text object completion
      -- to enable all native operators, set the preset / operators plugin above
      -- operators = { gc = "Comments" },
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
      },
      layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
      },
      show_help = true, -- show help message on the command line when the popup is visible
      spec = {
        { "<BS>", desc = "Decrement Selection", mode = "x" },
        { "<c-space>", desc = "Increment Selection", mode = { "x", "n" } },
      },
    },
    event = "VeryLazy",
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "lewis6991/gitsigns.nvim",
    firenvim = false,
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
    opts = {},
    keys = function()
      local gitsigns = require("gitsigns")
      return {
        {
          "<leader>gB",
          gitsigns.blame,
          desc = "Full file blame",
        },
        {
          "<leader>gj",
          function()
            gitsigns.nav_hunk("next", { navigation_message = false })
          end,
          desc = "Next Hunk",
        },
        {
          "<leader>gk",
          function()
            gitsigns.nav_hunk("prev", { navigation_message = false })
          end,
          desc = "Prev Hunk",
        },
        {
          "]h",
          function()
            gitsigns.nav_hunk("next", { navigation_message = false })
          end,
          desc = "Next Hunk",
        },
        {
          "[h",
          function()
            gitsigns.nav_hunk("prev", { navigation_message = false })
          end,
          desc = "Prev Hunk",
        },
        { "<leader>gl", gitsigns.blame_line, desc = "Blame" },
        {
          "<leader>gL",
          function()
            gitsigns.blame_line({ full = true })
          end,
          desc = "Blame Line (full)",
        },
        {
          "<leader>gp",
          gitsigns.preview_hunk,
          desc = "Preview Hunk",
        },
        {
          "<leader>gP",
          gitsigns.preview_hunk_inline,
          desc = "Preview Hunk Inline",
        },
        {
          "<leader>gr",
          gitsigns.reset_hunk,
          desc = "Reset Hunk",
        },
        {
          "<leader>gs",
          function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end,
          desc = "Stage Hunk",
          mode = { "v" },
        },
        {
          "<leader>gR",
          gitsigns.reset_buffer,
          desc = "Reset Buffer",
        },
        {
          "<leader>gs",
          gitsigns.stage_hunk,
          desc = "Stage Hunk",
        },
        {
          "<leader>gs",
          function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end,
          desc = "Stage Hunk",
          mode = { "v" },
        },
        { "<leader>gd", gitsigns.diffthis, desc = "Git Diff" },
        { "<leader>gtb", gitsigns.toggle_current_line_blame, desc = "Toggle Current Line Blame" },
        { "ih", ":<C-u>Gitsigns select_hunk<cr>", mode = { "o", "x" } },
      }
    end,
    event = "User FileOpened",
  },
  {
    "ggandor/leap.nvim",
    config = function()
      vim.keymap.set("n", "s", "<Plug>(leap-forward-to)", { silent = true })
      vim.keymap.set("x", "z", "<Plug>(leap-forward-to)", { silent = true })
      vim.keymap.set("o", "z", "<Plug>(leap-forward-to)", { silent = true })
      vim.keymap.set("n", "S", "<Plug>(leap-backward-to)", { silent = true })
      vim.keymap.set("x", "Z", "<Plug>(leap-backward-to)", { silent = true })
      vim.keymap.set("o", "Z", "<Plug>(leap-backward-to)", { silent = true })
      vim.keymap.set("x", "x", "<Plug>(leap-forward-till)", { silent = true })
      vim.keymap.set("o", "x", "<Plug>(leap-forward-till)", { silent = true })
      vim.keymap.set("x", "X", "<Plug>(leap-backward-till)", { silent = true })
      vim.keymap.set("o", "X", "<Plug>(leap-backward-till)", { silent = true })
      -- vim.keymap.set("n", "gs", "<Plug>(leap-cross-window)", { silent = true })
      -- vim.keymap.set("x", "gs", "<Plug>(leap-cross-window)", { silent = true })
      -- vim.keymap.set("o", "gs", "<Plug>(leap-cross-window)", { silent = true })
    end,
    event = "VeryLazy",
    vscode = true,
  },
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle",
    event = { "InsertLeave", "TextChanged" },
    config = function()
      local function in_snippets_dir(buf)
        for dir in vim.fs.parents(vim.api.nvim_buf_get_name(buf)) do
          if
            dir == ((os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config" or "") .. "/nvim/lua/luasnippets")
          then
            return true
          end
        end
        return false
      end
      require("auto-save").setup({
        condition = function(buf)
          local fn = vim.fn
          if vim.list_contains({ "oil" }, fn.getbufvar(buf, "&filetype")) then
            return false
          end
          return not in_snippets_dir(buf)
        end,
      })
      vim.g.auto_save_disabled = false
      Snacks.toggle({
        id = "autosave",
        name = "AutoSave",
        get = function()
          return not vim.g.auto_save_disabled
        end,
        set = function(state)
          vim.g.auto_save_disabled = not state
          vim.cmd("ASToggle")
        end,
      }):map("<leader>ua")
    end,
  },
  {
    "ethanholz/nvim-lastplace",
    event = "BufRead",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = {
          "gitcommit",
          "gitrebase",
          "svn",
          "hgcommit",
        },
        lastplace_open_folds = true,
      })
    end,
  },
}
