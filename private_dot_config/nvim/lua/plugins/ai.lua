return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = { enabled = true, auto_trigger = true, keymap = { accept = false } },
      panel = { enabled = false },
    },
    config = function(_, opts)
      require("copilot").setup(opts)
      Snacks.toggle({
        id = "copilot",
        name = "Copilot Suggestions",
        get = function()
          return not vim.b.copilot_suggestion_hidden
        end,
        set = function(state)
          vim.b.copilot_suggestion_hidden = not state
        end,
      }):map("<leader>up")
    end,
    cmd = "Copilot",
    event = "VeryLazy",
  },
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      strategies = {
        chat = {
          adapter = "copilot",
        },
        inline = {
          adapter = "copilot",
        },
      },
      display = {
        diff = {
          enabled = true,
          provider = "default",
        },
      },
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "claude-3.5-sonnet",
              },
            },
          })
        end,
      },
    },
  },
}
