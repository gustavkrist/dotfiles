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
    "folke/sidekick.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      require("sidekick").setup(opts)
      vim.g.sidekick_nes = not require("util.os").is_macos()
      Snacks.toggle({
        id = "nes",
        name = "NES",
        get = function()
          return vim.g.sidekick_nes
        end,
        set = function(state)
          vim.g.sidekick_nes = not state
        end,
      }):map("<leader>un")
    end,
    opts = {
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
        },
      },
    },
    keys = {
      {
        "<tab>",
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>" -- fallback to normal tab
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      {
        "<c-.>",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        -- function() require("sidekick.cli").select() end,
        -- Or to select only installed tools:
        function() require("sidekick.cli").select({ filter = { installed = true } }) end,
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function() require("sidekick.cli").close() end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      -- Example of a keybinding to open Claude directly
      {
        "<leader>ac",
        function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
        desc = "Sidekick Toggle Claude",
      },
    },
  }
}
