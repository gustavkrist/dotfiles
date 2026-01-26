return {
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
    "windwp/nvim-ts-autotag",
    opts = {},
    ft = { "html", "vue" },
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
    "Chaitanyabsprip/fastaction.nvim",
    opts = function()
      ---@param params GetActionConfigParams
      ---@return ActionConfig | nil
      local function get_action_config_from_priorities(params)
        if params.priorities == nil or #params.priorities == 0 then
          return nil
        end
        for _, priority in ipairs(params.priorities) do
          if
            not vim.tbl_contains(params.invalid_keys, priority.key)
            and params.title:lower():match(priority.pattern)
          then
            priority.order = priority.order or 10
            return priority
          end
        end
      end

      ---@param params GetActionConfigParams
      ---@return ActionConfig | nil
      local function get_action_config_from_title(params)
        if params.title == nil or params.title == "" or #params.valid_keys == 0 then
          return nil
        end
        local index = 1
        local increment = #params.valid_keys[1]
        params.title = string.lower(params.title)
        params.title, _ = string.gsub(params.title, "^ruff: ", "")
        params.title, _ = string.gsub(params.title, "^ruff %([a-z]+%d+%): ", "")
        repeat
          local char = params.title:sub(index, index + increment - 1)
          if
            char:match("[a-z]+")
            and not vim.tbl_contains(params.invalid_keys, char)
            and vim.tbl_contains(params.valid_keys, char)
          then
            return { key = char, order = 10 }
          end
          index = index + increment
        until index >= #params.title
      end

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
        register_ui_select = true,
        fallback_threshold = 4,
        override_function = function(params)
          if params.kind == "codeaction" then
            local res = get_action_config_from_priorities(params)
            if res then
              return res
            end
            return get_action_config_from_title(params)
          end
          return get_action_config_from_keys(params)
        end,
        popup = {
          relative = "cursor",
        },
        priority = {
          python = {
            { pattern = "fix all auto-fixable problems", key = "a", order = 2 },
            { pattern = "ruff: organize imports", key = "o", order = 1 },
          },
        },
      }
    end,
    keys = {
      {
        "<leader>la",
        function()
          require("fastaction").code_action()
        end,
        mode = { "n", "v" },
        desc = "Code Action",
      },
    },
    event = "VeryLazy",
  },
  {
    "stevearc/quicker.nvim",
    event = "FileType qf",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {
      keys = {
        {
          ">",
          function()
            require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
          end,
          desc = "Expand quickfix context",
        },
        {
          "<",
          function()
            require("quicker").collapse()
          end,
          desc = "Collapse quickfix context",
        },
      },
    },
    keys = {
      {
        "<leader>qo",
        function()
          require("quicker").toggle()
        end,
        desc = "Toggle quickfix",
      },
    },
  },
  {
    "klafyvel/vim-slime-cells",
    dependencies = { "jpalardy/vim-slime" },
    ft = { "markdown", "python" },
    init = function()
      vim.g.slime_no_mappings = 1
      vim.g.slime_bracketed_paste = 1
      vim.g.slime_cell_delimiter = "^#%%"
      vim.g.slime_target = "wezterm"
      vim.g.slime_default_config = { pane_direction = "right" }
    end,
    keys = {
      { "<localleader><cr>", "<Plug>SlimeCellsSendAndGoToNext", desc = "Send cell and go next", ft = { "python" } },
      { "<localleader><cr>", "<Plug>SlimeMotionSend", desc = "Send cell", ft = { "markdown" } },
      { "<localleader>j", "<Plug>SlimeCellsNext", desc = "Next cell", ft = { "python" } },
      { "<localleader>k", "<Plug>SlimeCellsPrev", desc = "Prev cell", ft = { "python" } },
      { "<localleader> ", "<Plug>SlimeLineSend", desc = "Send line", ft = { "markdown", "python" } },
      {

        "<localleader><localleader>",
        "<Plug>SlimeLineSend<cr>",
        desc = "Send line and go next",
        ft = { "markdown", "python" },
      },
      {
        "<localleader><cr>",
        "<Plug>SlimeRegionSend",
        desc = "Send selection",
        ft = { "markdown", "python" },
        mode = "x",
      },
      { "<localleader>s", "<Plug>SlimeMotionSend", desc = "Send motion", ft = { "markdown", "python" } },
      { "<localleader>c", "<Plug>SlimeConfig", desc = "Vim-slime config", ft = { "markdown", "python" } },
      {
        "<localleader>o",
        function()
          require("util.vim-slime").add_cell_below("#%%")
        end,
        desc = "New cell below",
        ft = { "python" },
      },
      {
        "<localleader>O",
        function()
          require("util.vim-slime").add_cell_above("#%%")
        end,
        desc = "New cell above",
        ft = { "python" },
      },
    },
  },
  {
    "folke/trouble.nvim",
    opts = {},
    specs = {
      "folke/snacks.nvim",
      opts = function(_, opts)
        return vim.tbl_deep_extend("force", opts or {}, {
          picker = {
            actions = require("trouble.sources.snacks").actions,
            win = {
              input = {
                keys = {
                  ["<c-t>"] = {
                    "trouble_open",
                    mode = { "n", "i" },
                  },
                },
              },
            },
          },
        })
      end,
    },
    cmd = { "Trouble" },
    keys = {
      {
        "[x",
        function()
          require("trouble").prev()
          require("trouble").jump()
        end,
        desc = "Previous Trouble Item",
        mode = "n",
      },
      {
        "]x",
        function()
          require("trouble").next()
          require("trouble").jump()
        end,
        desc = "Next Trouble Item",
        mode = "n",
      },
    },
  },
  {
    "xzbdmw/clasp.nvim",
    opts = {},
    keys = {
      {
        "<c-l>",
        function()
          require("clasp").wrap("next")
        end,
        mode = { "i" },
        desc = "Increment wrap",
      },
    },
  },
  {
    "chrisgrieser/nvim-scissors",
    event = "VeryLazy",
    opts = {
      snippetSelection = {
        picker = "snacks",
      },
      jsonFormatter = "jq",
      backdrop = {
        enabled = false,
      },
    },
  },
}
