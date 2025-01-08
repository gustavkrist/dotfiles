local function no_firenvim()
  return not require("util.firenvim").get()
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dim = { enabled = true },
    indent = { animate = { enabled = false } },
    lazygit = {
      theme = {
        [241] = { fg = "Special" },
        activeBorderColor = { fg = "String", bold = true },
        cherryPickedCommitBgColor = { fg = "Identifier" },
        cherryPickedCommitFgColor = { fg = "Function" },
        defaultFgColor = { fg = "Normal" },
        inactiveBorderColor = { fg = "Normal" },
        optionsTextColor = { fg = "Function" },
        searchingActiveBorderColor = { fg = "MatchParen", bold = true },
        selectedLineBgColor = { bg = "Visual" }, -- set to `default` to have no background colour
        unstagedChangesColor = { fg = "DiagnosticError" },
      },
    },
    notifier = {
      enabled = no_firenvim(),
    },
    quickfile = { enabled = true },
    terminal = {
      win = {
        style = "float",
        height = 0.85,
        width = 0.85,
        wo = {
          winhighlight = "FloatBorder:Normal,NormalFloat:Normal",
        },
        border = "rounded",
        keys = {
          hide_term = {
            "<C-t>",
            "hide",
            mode = { "n", "t" },
          },
        },
      },
    },
    zen = {
      enabled = true,
      toggles = {
        git_signs = true,
      },
      on_open = function()
        local lualine_ok, lualine = pcall(require, "lualine")
        if lualine_ok then
          lualine.hide()
          vim.api.nvim_set_option_value("winbar", "", { scope = "local" })
          vim.o.laststatus = 0
        end
      end,
      on_close = function()
        local lualine_ok, lualine = pcall(require, "lualine")
        if lualine_ok then
          lualine.hide({ unhide = true })
        end
      end,
    },
  },
  keys = function()
    local openingh = require("util.git").gitbrowse_with_branch
    return {
      {
        "<C-t>",
        function()
          Snacks.terminal.toggle()
        end,
        mode = { "i", "n", "v" },
        desc = "Toggle floating terminal",
      },
      {
        "<leader>m",
        function()
          Snacks.notifier.show_history()
        end,
        mode = "n",
        desc = "Show notification history",
      },
      {
        "<leader>gg",
        function()
          Snacks.lazygit.open()
        end,
        mode = "n",
        desc = "Open LazyGit",
      },
      {
        "<leader>ogr",
        function()
          openingh("repo")
        end,
        mode = "n",
        desc = "Open repo in Git remote",
      },
      {
        "<leader>ogf",
        function()
          openingh("file")
        end,
        mode = "n",
        desc = "Open file in Git remote",
      },
      {
        "<leader>ogl",
        function()
          openingh("file", "v")
        end,
        mode = "v",
        desc = "Open selected lines in Git remote",
      },
    }
  end,
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle
          .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
          :map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ui")
        Snacks.toggle.zen():map("<leader>uz")

        require("util.plugins").on_load("which-key.nvim", function()
          require("which-key").add({ "<leader>og", group = "Open in GitHub..." })
        end)
        vim.api.nvim_create_autocmd("User", {
          pattern = "MiniFilesActionRename",
          callback = function(event)
            Snacks.rename.on_rename_file(event.data.from, event.data.to)
          end,
        })
      end,
    })
  end,
}
