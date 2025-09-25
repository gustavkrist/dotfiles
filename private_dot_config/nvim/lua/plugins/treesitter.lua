return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = vim.fn.argc(-1) == 0,  -- load treesitter early when opening a file from the cmdline
    event = { "User FileOpened", "VeryLazy" },
    cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
    branch = "main",
    vscode = true,
    build = function()
      vim.cmd.TSUpdate()
    end,
    opts_extend = {" ensure_installed" },
    opts = {
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
      }
    },
    config = function(_, opts)
      local parsers = require("nvim-treesitter.parsers")

      -- Setup https://github.com/ionide/tree-sitter-fsharp
      parsers.fsharp = {
        install_info = {
          url = "https://github.com/ionide/tree-sitter-fsharp",
          branch = "main",
          files = { "src/scanner.c", "src/parser.c" },
          location = "fsharp",
          generate = false,
        },
        filetype = "fsharp",
      }

      parsers.lua_patterns = {
        install_info = {
          url = "https://github.com/OXY2DEV/tree-sitter-lua_patterns",
          branch = "main",
          files = { "src/parser.c" },
          generate = false,
        },
      }

      require("nvim-treesitter").setup(opts)

      local needed = opts.ensure_installed
      local installed = require("nvim-treesitter").get_installed("parsers")
      local to_install = vim.tbl_filter(function(lang)
        return not vim.tbl_contains(installed, vim.treesitter.language.get_lang(lang))
      end, needed)

      if #to_install > 0 then
        require("nvim-treesitter").install(to_install, { summary = true })
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    branch = "main",
    event = "VeryLazy",
    vscode = true,
    opts = {},
    keys = function()
      local moves = {
        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
      }
      local ret = {} ---@type LazyKeysSpec[]
      for method, keymaps in pairs(moves) do
        for key, query in pairs(keymaps) do
          local desc = query:gsub("@", ""):gsub("%..*", "")
          desc = desc:sub(1, 1):upper() .. desc:sub(2)
          desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
          desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
          ret[#ret + 1] = {
            key,
            function()
              -- don't use treesitter if in diff mode and the key is one of the c/C keys
              if vim.wo.diff and key:find("[cC]") then
                return vim.cmd("normal! " .. key)
              end
              require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
            end,
            desc = desc,
            mode = { "n", "x", "o" },
            silent = true,
          }
        end
      end
      return ret
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
            vim.cmd("TSContext disable")
          else
            vim.cmd("TSContext enable")
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
      { "<M-j>", "<cmd>Treewalker Down<cr>" },
      { "<M-k>", "<cmd>Treewalker Up<cr>" },
      { "<M-h>", "<cmd>Treewalker Left<cr>" },
      { "<M-l>", "<cmd>Treewalker Right<cr>" },
      { "<C-M-j>", "<cmd>Treewalker SwapDown<cr>" },
      { "<C-M-k>", "<cmd>Treewalker SwapUp<cr>" },
      { "<C-M-h>", "<cmd>Treewalker SwapLeft<cr>" },
      { "<C-M-l>", "<cmd>Treewalker SwapRight<cr>" },
    },
  },
}
