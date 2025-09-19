return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<M-l>",
          accept_line = "<M-h>",
          accept_word = "<M-k>",
        },
      },
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
    config = function(_, opts)
      require("codecompanion").setup(opts)
      vim.keymap.set("ca", "cc", "CodeCompanion")
    end,
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
    },
    keys = {
      { "<leader>at", "<cmd>CodeCompanionChat Toggle<CR>", mode = { "n", "v" }, desc = "Toggle AI Chat" },
      { "<leader>aa", "<cmd>CodeCompanionActions<CR>", mode = { "n", "v" }, desc = "Select AI Action" },
      { "<leader>aA", "<cmd>CodeCompanionChat Add<CR>", mode = "v", desc = "Add code to AI chat" },
    },
  },
}
