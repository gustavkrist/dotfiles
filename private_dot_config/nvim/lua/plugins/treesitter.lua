return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "master",
    build = ":TSUpdate",
    vscode = true,
    keys = {
      { "<c-space>", desc = "Increment Selection" },
      { "<bs>", desc = "Decrement Selection", mode = "x" },
    },
    config = function()
      local configs = require("nvim-treesitter.configs")
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

      -- Setup https://github.com/ionide/tree-sitter-fsharp
      parser_config.fsharp = {
        install_info = {
          url = "https://github.com/ionide/tree-sitter-fsharp",
          branch = "main",
          files = { "src/scanner.c", "src/parser.c" },
          location = "fsharp",
        },
        requires_generate_from_grammar = false,
        filetype = "fsharp",
      }

      parser_config.lua_patterns = {
        install_info = {
          url = "https://github.com/OXY2DEV/tree-sitter-lua_patterns",
          branch = "main",
          files = { "src/parser.c" },
        },
        requires_generate_from_grammar = false,
      }

      configs.setup({
        ensure_installed = {
          "bash",
          "c",
          "diff",
          "fsharp",
          "html",
          "javascript",
          "jsdoc",
          "json",
          "jsonc",
          "latex",
          "lua",
          "luadoc",
          "luap",
          "markdown",
          "markdown_inline",
          "printf",
          "python",
          "query",
          "regex",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "vue",
          "xml",
          "yaml",
        },
        sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
        ignore_install = { "" }, -- List of parsers to ignore installing
        autopairs = {
          enable = true,
        },
        highlight = {
          enable = true, -- false will disable the whole extension
          disable = { "" }, -- list of language that will be disabled
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
        indent = { enable = true, disable = { "yaml" } },
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
        textobjects = {
          move = {
            enable = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]a"] = "@parameter.inner",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
              ["]A"] = "@parameter.inner",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[a"] = "@parameter.inner",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
              ["[A"] = "@parameter.inner",
            },
          },
        },
        endwise = {
          enable = true,
        },
      })
    end,
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    cmd = {
      "TSInstall",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
      "TSInstallInfo",
      "TSInstallSync",
      "TSInstallFromGrammar",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    branch = "master",
    event = "VeryLazy",
    vscode = true,
    config = function()
      -- If treesitter is already loaded, we need to run config again for textobjects
      if require("util.plugins").is_loaded("nvim-treesitter") then
        require("nvim-treesitter.configs").setup({
          textobjects = {
            move = {
              enable = true,
              goto_next_start = {
                ["]f"] = "@function.outer",
                ["]c"] = "@class.outer",
                ["]a"] = "@parameter.inner",
              },
              goto_next_end = {
                ["]F"] = "@function.outer",
                ["]C"] = "@class.outer",
                ["]A"] = "@parameter.inner",
              },
              goto_previous_start = {
                ["[f"] = "@function.outer",
                ["[c"] = "@class.outer",
                ["[a"] = "@parameter.inner",
              },
              goto_previous_end = {
                ["[F"] = "@function.outer",
                ["[C"] = "@class.outer",
                ["[A"] = "@parameter.inner",
              },
            },
          },
        })
      end

      -- When in diff mode, we want to use the default
      -- vim text objects c & C instead of the treesitter ones.
      local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
      local configs = require("nvim-treesitter.configs")
      for name, fn in pairs(move) do
        if name:find("goto") == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
              for key, query in pairs(config or {}) do
                if q == query and key:find("[%]%[][cC]") then
                  vim.cmd("normal! " .. key)
                  return
                end
              end
            end
            return fn(q, ...)
          end
        end
      end
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    config = function(_, opts)
      require("treesitter-context").setup(opts)
      vim.g.treesitter_context_disabled = false
      Snacks.toggle({
        id = "tscontext",
        name = "Treesitter Context",
        get = function()
          return not vim.g.treesitter_context_disabled
        end,
        set = function(state)
          if not state then
            vim.cmd("TSContextDisable")
          else
            vim.cmd("TSContextEnable")
          end
          vim.g.treesitter_context_disabled = not state
        end,
      }):map("<leader>ux")
    end,
    opts = {
      multiline_threshold = 8,
      separator = "─"
    },
    keys = {
      {
        "[X",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        mode = { "n", "v" },
        desc = "Goto treesitter conte[x]t",
      },
    },
  },
  {
    "mtrajano/tssorter.nvim",
    vscode = true,
    version = "*",
    ---@module "tssorter"
    ---@type TssorterOpts
    opts = {},
    cmd = "TSSort",
  },
  {
    "RRethy/nvim-treesitter-endwise",
    ft = { "lua", "bash", "zsh" },
  },
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
  },
  {
    "aaronik/treewalker.nvim",
    keys = {
      { "<C-j>", "<cmd>Treewalker Down<cr>" },
      { "<C-k>", "<cmd>Treewalker Up<cr>" },
      { "<C-h>", "<cmd>Treewalker Left<cr>" },
      { "<C-l>", "<cmd>Treewalker Right<cr>" },
      { "<C-M-j>", "<cmd>Treewalker SwapDown<cr>" },
      { "<C-M-k>", "<cmd>Treewalker SwapUp<cr>" },
      { "<C-M-h>", "<cmd>Treewalker SwapLeft<cr>" },
      { "<C-M-l>", "<cmd>Treewalker SwapRight<cr>" },
    },
  },
}
