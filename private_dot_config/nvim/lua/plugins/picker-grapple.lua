return {
  {
    "cbochs/grapple.nvim",
    firenvim = false,
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true },
    },
    config = function(_, opts)
      require("grapple").setup(opts)
      require("util.plugins").on_load("telescope.nvim", function()
        require("telescope").load_extension("grapple")
        vim.keymap.set(
          "n",
          "<leader>ht",
          "<cmd>Telescope grapple tags theme=dropdown<cr>",
          { desc = "Telescope grapple tags" }
        )
      end)
    end,
    opts = {
      scope = "git_branch",
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = "Grapple",
    keys = {
      { "<leader>hm", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle tag" },
      { "<leader>hh", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple open tags window" },
      { "<leader>hs", "<cmd>Grapple open_scopes<cr>", desc = "Grapple open scopes window" },
      { "<leader>hl", "<cmd>Grapple open_loaded<cr>", desc = "Grapple open loaded scopes window" },
      { "<leader>1", "<cmd>Grapple select index=1<cr>", desc = "[Grapple] Select first tag" },
      { "<leader>2", "<cmd>Grapple select index=2<cr>", desc = "[Grapple] Select second tag" },
      { "<leader>3", "<cmd>Grapple select index=3<cr>", desc = "[Grapple] Select third tag" },
      { "<leader>4", "<cmd>Grapple select index=4<cr>", desc = "[Grapple] Select fourth tag" },
      { "<leader>5", "<cmd>Grapple select index=5<cr>", desc = "[Grapple] Select fifth tag" },
      { "<leader>h<Tab>", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag" },
      { "<leader>h<S-tab>", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle previous tag" },
      { "<Tab>", "<cmd>Grapple cycle_tags next<cr>" },
      { "<S-Tab>", "<cmd>Grapple cycle_tags prev<cr>" },
    },
  },
  {
    "will-lynas/grapple-line.nvim",
    firenvim = false,
    dependencies = {
      "cbochs/grapple.nvim",
    },
    version = "1.x",
    opts = {
      number_of_files = 4,
      colors = {
        active = "lualine_a_normal",
        inactive = "@comment",
      },
      -- Accepted values:
      -- "unique_filename" shows the filename and parent directories if needed
      -- "filename" shows the filename only
      mode = "unique_filename",
      -- If a tag name is set, use that instead of the filename
      show_names = false,
      -- Accepted values:
      -- "none" - overflowing files are ignored
      -- "ellipsis" - if there are overflowing files an ellipsis will be shown
      overflow = "ellipsis",
      -- Files for which the parent directory should always be shown
      always_show_parent = {},
    },
    lazy = true,
  },
  {
    "nvim-telescope/telescope.nvim",
    firenvim = false,
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
        lazy = true,
      },
    },
    config = function(_, opts)
      require("telescope").load_extension("fzf")
      require("telescope").setup(opts)
    end,
    opts = function()
      local actions = require("telescope.actions")
      return {
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
        pickers = {
          buffers = {
            path_display = {
              "shorten",
            },
          },
        },
        defaults = {
          mappings = {
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
          },
          layout_strategy = "center",
        },
      }
    end,
    lazy = true,
  },
}
