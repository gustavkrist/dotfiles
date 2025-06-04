return {
  {
    "L3MON4D3/LuaSnip",
    config = function(_, opts)
      require("luasnip.loaders.from_lua").lazy_load({
        paths = { "./lua/luasnippets" },
        fs_event_providers = {
          autocmd = false,
          libuv = true,
        },
      })
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { "./snippets" },
        fs_event_providers = { autocmd = false, livuv = true },
      })
      require("luasnip").filetype_extend("latex", { "tex" })
      require("luasnip").filetype_extend("markdown_inline", { "markdown" })
      require("luasnip").setup(opts)
    end,
    opts = function()
      local types = require("luasnip.util.types")
      return {
        delete_check_events = "InsertLeave",
        enable_autosnippets = true,
        store_selection_keys = "<Tab>",
        ft_func = require("luasnip.extras.filetype_functions").from_pos_or_filetype,
        load_ft_func = require("luasnip.extras.filetype_functions").extend_load_ft({
          markdown = { "tex", "python", "sql", "vue" },
        }),
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { "●", "@comment.warning" } },
            },
          },
          [types.insertNode] = {
            active = {
              virt_text = { { "●", "@boolean" } },
            },
          },
        },
      }
    end,
    version = "v2.*",
    build = "make install_jsregexp",
    event = "InsertEnter",
    keys = {
      { "<C-n>", "<Plug>luasnip-next-choice", mode = "i" },
      { "<C-n>", "<Plug>luasnip-next-choice", mode = "s" },
      { "<C-p>", "<Plug>luasnip-prev-choice", mode = "i" },
      { "<C-p>", "<Plug>luasnip-prev-choice", mode = "s" },
      { "<C-u>", "<cmd>lua require('luasnip.extras.select_choice')()<cr>", mode = "i" },
      { "<C-u>", "<cmd>lua require('luasnip.extras.select_choice')()<cr>", mode = "s" },
      { "<leader>se", "<cmd>lua require('luasnip.loaders').edit_snippet_files()<CR>", desc = "Edit snippets" },
    },
  },
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = {
      { "L3MON4D3/LuaSnip", version = "v2.*" },
      {
        "saghen/blink.compat",
        opts = {},
        lazy = true,
        version = "*",
      },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      completion = {
        keyword = { range = "prefix" },
        accept = { auto_brackets = { enabled = true } },
        list = { selection = { preselect = false, auto_insert = true } },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          window = {
            border = "rounded",
          },
        },
        menu = {
          border = "rounded",
          winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
          draw = {
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "source_name" },
            },
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
            },
          },
        },
      },
      keymap = {
        preset = "none",
        ["<Down>"] = { "select_next", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-Space>"] = {
          function(cmp)
            if cmp.is_visible() then
              cmp.hide()
            else
              cmp.show()
            end
          end,
        },
        ["<C-e>"] = { "hide", "fallback" },
        ["<C-y>"] = { "select_and_accept" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<Esc>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = {
          function(cmp)
            if require("luasnip").expand_or_locally_jumpable() then
              cmp.hide()
              vim.schedule(require("luasnip").expand_or_jump)
              return true
            else
              return
            end
          end,
          "snippet_forward",
          "select_next",
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
      },
      snippets = {
        preset = "luasnip",
      },
      cmdline = {
        sources = function()
          local type = vim.fn.getcmdtype()
          -- Search forward and backward
          if type == "/" or type == "?" then
            return { "buffer" }
          end
          -- Commands
          if type == ":" then
            return { "cmdline" }
          end
          return {}
        end,
      },
      sources = {
        default = {
          "lsp",
          "path",
          "buffer",
          "snippets",
          "lazydev",
        },
        providers = {
          lsp = {
            name = "[LSP]",
            enabled = true,
            module = "blink.cmp.sources.lsp",
            fallbacks = { "snippets", "buffer" },
            score_offset = 90,
          },
          path = {
            name = "[Path]",
            module = "blink.cmp.sources.path",
            fallbacks = { "snippets", "buffer" },
            score_offset = 3,
            opts = {
              trailing_slash = false,
              label_trailing_slash = true,
            },
          },
          buffer = {
            name = "[Buffer]",
            module = "blink.cmp.sources.buffer",
            min_keyword_length = 2,
          },
          snippets = {
            name = "[Snippet]",
            enabled = true,
            module = "blink.cmp.sources.snippets",
            score_offset = 80,
          },
          lazydev = {
            name = "[Lazydev]",
            module = "lazydev.integrations.blink",
            score_offset = 80,
          },
        },
      },
    },
    event = { "InsertEnter", "CmdlineEnter" },
    enabled = true,
  },
}
