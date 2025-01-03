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
    opts = {
      select = {
        enabled = false,
      },
    },
    event = "VeryLazy",
  },
  {
    "Chaitanyabsprip/fastaction.nvim",
    dependencies = { "stevearc/dressing.nvim" },
    opts = function()
      ---@param params GetActionConfigParams
      ---@return ActionConfig | nil
      local function get_action_config_from_priorities(params)
          if params.priorities == nil or #params.priorities == 0 then return nil end
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
          if params.title == nil or params.title == '' or #params.valid_keys == 0 then return nil end
          local index = 1
          local increment = #params.valid_keys[1]
          params.title = string.lower(params.title)
          params.title, _ = string.gsub(params.title, "^ruff: ", "")
          params.title, _ = string.gsub(params.title, "^ruff %([a-z]+%d+%): ", "")
          repeat
              local char = params.title:sub(index, index + increment - 1)
              if
                  char:match '[a-z]+'
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
        fallback_threshold = 10,
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
