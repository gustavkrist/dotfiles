return {
  {
    "catgoose/nvim-colorizer.lua",
    config = function(_, opts)
      require("colorizer").setup(#opts > 0 and opts or nil)
    end,
    opts = {},
    lazy = false,
    event = "BufReadPre",
    keys = {
      { "<leader>uc", "<cmd>ColorizerToggle<cr>", desc = "Toggle Colorizer" },
    },
  },
  {
    "folke/todo-comments.nvim",
    opts = {},
    event = "User FileOpened",
    keys = {
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Prev todo comment",
      },
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment",
      },
      {
        "<leader>st",
        function()
          Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
        end,
        desc = "Search Todo-Comments",
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    cond = false,
    opts = function()
      local icons = require("util.icons")
      local bl_util = require("util.bufferline")
      return {
        highlights = {
          background = {
            italic = true,
          },
          buffer_selected = {
            bold = true,
          },
        },
        options = {
          themable = true, -- whether or not bufferline highlights can be overridden externally
          show_duplicate_prefix = true,
          duplicates_across_groups = true,
          auto_toggle_bufferline = true,
          groups = { items = {}, options = { toggle_hidden_on_enter = true } },
          mode = "buffers", -- set to "tabs" to only show tabpages instead
          numbers = "none", -- can be "none" | "ordinal" | "buffer_id" | "both" | function
          close_command = function(bufnr) -- can be a string | function, see "Mouse actions"
            bl_util.buf_kill("bd", bufnr, false)
          end,
          right_mouse_command = "vert sbuffer %d", -- can be a string | function, see "Mouse actions"
          left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
          middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
          indicator = {
            icon = icons.ui.BoldLineLeft, -- this should be omitted if indicator style is not 'icon'
            style = "icon", -- can also be 'underline'|'none',
          },
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          diagnostics_indicator = bl_util.diagnostics_indicator,
          -- NOTE: this will be called a lot so don't do any heavy processing here
          custom_filter = bl_util.get_filter_func(),
          offsets = {
            {
              filetype = "undotree",
              text = "Undotree",
              highlight = "PanelHeading",
              padding = 1,
            },
            {
              filetype = "NvimTree",
              text = "Explorer",
              highlight = "PanelHeading",
              padding = 1,
            },
            {
              filetype = "DiffviewFiles",
              text = "Diff View",
              highlight = "PanelHeading",
              padding = 1,
            },
            {
              filetype = "flutterToolsOutline",
              text = "Flutter Outline",
              highlight = "PanelHeading",
            },
            {
              filetype = "lazy",
              text = "Lazy",
              highlight = "PanelHeading",
              padding = 1,
            },
          },
          color_icons = true, -- whether or not to add the filetype icon highlights
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = false,
          show_tab_indicators = true,
          persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
          -- can also be a table containing 2 custom separators
          -- [focused and unfocused]. eg: { '|', '|' }
          separator_style = "thin",
          enforce_regular_tabs = false,
          always_show_bufferline = false,
          hover = {
            enabled = true, -- requires nvim 0.8+
            delay = 200,
            reveal = { "close" },
          },
          sort_by = bl_util.get_sort_func(),
          debug = { logging = false },
        },
      }
    end,
    event = "VeryLazy",
  },
  {
    "folke/noice.nvim",
    firenvim = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    commit = "eaed6cc9c06aa2013b5255349e4f26a6b17ab70f",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        progress = {
          enabled = false,
          throttle = 100,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
        {
          filter = {
            event = "msg_showmode",
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = false,
        command_palette = false,
        long_message_to_split = true,
        lsp_doc_border = true,
        inc_rename = true,
      },
      views = {
        mini = {
          win_options = {
            winblend = 0,
          },
        },
      },
    },
    keys = {
      {
        "<S-CR>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "Redirect Cmdline",
      },
      -- { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      -- { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      -- { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      -- { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      -- { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice Picker (Telescope/FzfLua)" },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-f>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Forward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-b>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Backward",
        mode = { "i", "n", "s" },
      },
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end
      require("noice").setup(opts)
    end,
  },
  {
    "MunifTanjim/nui.nvim",
    firenvim = false,
    lazy = true,
  },
  {
    "smjonas/inc-rename.nvim",
    opts = {},
    cmd = "IncRename",
    keys = {
      {
        "<leader>lr",
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        desc = "Rename",
        expr = true,
      },
    },
  },
  {
    "kosayoda/nvim-lightbulb",
    opts = {
      autocmd = { enabled = true },
      filter = function(_, result)
        return not vim.tbl_contains({
          "source.fixAll.ruff",
          "source.organizeImports.ruff",
        }, result.kind)
      end,
    },
  },
}
