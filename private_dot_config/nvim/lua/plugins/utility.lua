return {
  {
    "akinsho/toggleterm.nvim",
    cond = function()
      return not require("util.firenvim").get()
    end,
    version = "*",
    opts = {
      open_mapping = "<C-t>",
      direction = "float",
      start_in_insert = true,
      persist_mode = false,
    },
    cmd = {
      "ToggleTerm",
      "TermExec",
      "ToggleTermToggleAll",
      "ToggleTermSendCurrentLine",
      "ToggleTermSendVisualLines",
      "ToggleTermSendVisualSelection",
    },
    lazy = true,
    keys = function()
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
      local function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end
      return {
        "<C-t>",
        {
          "<C-t>",
          "<cmd>execute v:count . 'ToggleTerm'<CR>",
          desc = "Toggle Terminal",
          noremap = true,
          silent = true,
        },
        {
          "<C-t>",
          "<Esc><cmd>ToggleTerm<CR>",
          desc = "Toggle Terminal",
          noremap = true,
          silent = true,
        },
        { "<leader>gg", _LAZYGIT_TOGGLE, desc = "Lazygit" },
        { "<leader>tg", _LAZYGIT_TOGGLE, desc = "Lazygit" },
        { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float" },
        { "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal" },
        { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical" },
      }
    end,
  },
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    keys = function()
      local function grug_project_root()
        local grug = require("grug-far")
        -- local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
        grug.open({
          transient = true,
          prefills = {
            paths = require("util.root")(),
            -- filesFilter = ext and ext ~= "" and "*." .. ext or nil,
          },
        })
      end
      return {
        { "<leader>sg", grug_project_root, mode = { "n", "v" }, desc = "[Grug] Search & Replace" },
      }
    end,
    cmd = "GrugFar",
  },
  {
    "almo7aya/openingh.nvim",
    config = function()
      require("util.plugins").on_load("which-key.nvim", function()
        require("which-key").add({ "<leader>og", group = "Open in GitHub..." })
      end)
    end,
    keys = function()
      local openingh = require("util.git").run_openingh_with_picked_ref
      return {
        { "<leader>ogr", "<cmd>OpenInGHRepo<cr>", desc = "Open repo in GitHub" },
        {
          "<leader>ogf",
          function()
            openingh("OpenInGHFile")
          end,
          mode = "n",
          desc = "Open file in GitHub",
        },
        {
          "<leader>ogl",
          function()
            openingh("OpenInGHFileLines")
          end,
          mode = "n",
          desc = "Open line(s) in GitHub",
        },
        {
          "<leader>ogl",
          function()
            openingh("OpenInGHFileLines", "v")
          end,
          mode = "v",
          desc = "Open line(s) in GitHub",
        },
      }
    end,
    cmd = { "OpenInGHRepo", "OpenInGHFile", "OpenInGHFileLines" },
  },
  {
    "windwp/nvim-ts-autotag",
    opts = {},
    ft = { "html", "vue" },
  },
  {
    "folke/zen-mode.nvim",
    dependencies = {
      { "folke/twilight.nvim", lazy = true, opts = { dimming = { term_bg = "#2E3440" } } },
    },
    opts = {
      window = {
        options = {
          number = false,
          relativenumber = false,
        },
      },
      plugins = {
        gitsigns = {
          enabled = true,
        },
        wezterm = {
          enabled = true,
          font = "+2",
        },
        neovide = {
          enabled = true,
        },
      },
      on_open = function()
        local lualine_ok, lualine = pcall(require, "lualine")
        if lualine_ok then
          lualine.hide()
          vim.api.nvim_set_option_value("winbar", "", { scope = "local" })
          vim.o.laststatus = 0
        end
        local ibl_ok, ibl = pcall(require, "ibl")

        if ibl_ok then
          ibl.update({ enabled = false })
        end
      end,
      on_close = function()
        local lualine_ok, lualine = pcall(require, "lualine")
        if lualine_ok then
          lualine.hide({ unhide = true })
        end
        if ibl_ok then
          ibl.update({ enabled = true })
        end
      end,
    },
    cmd = "ZenMode",
    keys = {
      {
        "<leader>uz",
        function()
          require("zen-mode").toggle()
        end,
        desc = "Toggle Zen Mode",
      },
    },
  },
  {
    "xvzc/chezmoi.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function(_, opts)
      require("chezmoi").setup(opts)
      require("util.plugins").on_load("telescope.nvim", function()
        require("telescope").load_extension("chezmoi")
        vim.keymap.set(
          "n",
          "<leader>oc",
          require("telescope").extensions.chezmoi.find_files,
          { desc = "Edit chezmoi files" }
        )
      end)
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
        callback = function(ev)
          local bufnr = ev.buf
          local edit_watch = function()
            require("chezmoi.commands.__edit").watch(bufnr)
          end
          vim.schedule(edit_watch)
        end,
      })
    end,
    opts = {},
    keys = { { "<leader>oc", desc = "Edit chezmoi files" } },
  },
  {
    "kmonad/kmonad-vim",
  },
  {
    "chrishrb/gx.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      open_browser_app = vim.fn.has("wsl") == 1 and "powershell.exe" or nil,
      open_browser_args = vim.fn.has("wsl") == 1 and { "start", "explorer.exe" } or nil,
    },
    cmd = { "Browse" },
    keys = {
      { "gx", "<cmd>Browse<cr>", desc = "Open text under cursor", mode = "n" },
      { "gx", "<Esc>:Browse<cr>", desc = "Open selected text", mode = "x" },
    },
  },
  {
    "stevearc/dressing.nvim",
    cond = function()
      return not require("util.firenvim").get()
    end,
    event = "VeryLazy",
  },
  {
    "gustavkrist/fastaction.nvim",
    dependencies = { "stevearc/dressing.nvim" },
    config = function(_, opts)
      local fastaction = require("fastaction")
      fastaction.setup(opts)
      vim.ui.select = function(items, opts, on_choice)
        opts = opts or {}
        opts.relative = "win"
        opts.centered = true
        fastaction.select(items, opts, on_choice)
      end
    end,
    opts = function()
      ---@param params GetActionConfigParams
      ---@return ActionConfig | nil
      local function get_action_config_from_keys(params)
        if #params.valid_keys == nil or #params.valid_keys == 0 then
          return nil
        end
        for _, k in pairs(params.valid_keys) do
          if not vim.tbl_contains(params.invalid_keys, k) then
            return { key = k, order = 0 }
          end
        end
      end

      return {
        dismiss_keys = { "<C-c>", "<Esc>", "q" },
        override_function = get_action_config_from_keys,
        register_ui_select = true,
        fallback_threshold = 15,
      }
    end,
    event = "VeryLazy",
  },
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    config = function(_, opts)
      require("hardtime").setup(opts)
      vim.keymap.set("n", "<leader>ut", "<cmd>Hardtime toggle<cr>", { desc = "Toggle Hardtime" })
    end,
    event = "User FileOpened",
    opts = {
      disabled_keys = {
        ["<Up>"] = {},
        ["<Down>"] = {},
        ["<Left>"] = {},
        ["<Right>"] = {},
      },
      disable_mouse = false,
    },
  },
}
