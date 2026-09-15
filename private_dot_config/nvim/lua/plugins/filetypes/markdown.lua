return {
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npx --yes yarn install",
    init = function()
      if os.getenv("WSL_DISTRO_NAME") ~= nil then
        vim.g.browser = "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
      elseif vim.loop.os_uname().sysname == "Darwin" then
        vim.cmd([[
        function! ChromeUrl(url)
          call system("osascript " . $HOME . "/scripts/chrome_new_window.scpt " . a:url)
        endfunction
        ]])
        vim.g.mkdp_browserfunc = "ChromeUrl"
      end
      vim.g.mkdp_filetypes = { "markdown" }
      vim.cmd([[
      let g:mkdp_preview_options = {
          \ 'mkit': {},
          \ 'katex': {'macros': {
            \ "\\Xn": "X_1, \\ldots, X_n",
            \ "\\abs": "\\lvert #1 \\rvert",
            \ "\\ber": "\\operatorname{Ber}",
            \ "\\bin": "\\operatorname{Bin}",
            \ "\\ceil": "\\lceil #1 \\rceil",
            \ "\\cov": "\\operatorname{Cov}",
            \ "\\diff": "\\mathop{}\\!\\mathrm{d}",
            \ "\\expdist": "\\operatorname{Exp}",
            \ "\\expect": "\\operatorname{E}",
            \ "\\floor": "\\lfloor #1 \\rfloor",
            \ "\\geo": "\\operatorname{Geo}",
            \ "\\given": "\\,\\vert\\,",
            \ "\\inv": "#1^{\\text{inv}}",
            \ "\\mean": "\\overline{#1}",
            \ "\\med": "\\operatorname{Med}",
            \ "\\normdist": "\\operatorname{N}",
            \ "\\prob": "\\operatorname{P}",
            \ "\\unif": "\\operatorname{U}",
            \ "\\var": "\\operatorname{Var}",
            \ "\\xn": "x_1, \\ldots, x_n"
            \ }},
          \ 'uml': {},
          \ 'maid': {},
          \ 'disable_sync_scroll': 0,
          \ 'sync_scroll_type': 'middle',
          \ 'hide_yaml_meta': 1,
          \ 'sequence_diagrams': {},
          \ 'flowchart_diagrams': {},
          \ 'content_editable': v:false,
          \ 'disable_filename': 0,
          \ 'toc': {}
          \ }
      ]])
      vim.g.mkdp_markdown_css = os.getenv("HOME") .. "/.config/nvim/styles/markdown-preview.css"
    end,
    ft = { "markdown" },
  },
  {
    "obsidian-nvim/obsidian.nvim",
    ft = "markdown",
    keys = {
      { "<localleader>ip", "<cmd>Obsidian paste_img<cr>", desc = "Paste image from clipboard", ft = "markdown" },
    },
    opts = {
      workspaces = {
        {
          name = "Notes",
          path = "~/obsidian-vaults/notes",
        },
        {
          name = "no-vault",
          path = function()
            return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
          end,
          overrides = {
            notes_subdir = vim.NIL,
            new_notes_location = "current_dir",
            templates = {
              folder = vim.NIL,
            },
            frontmatter = {
              enabled = false,
            },
          },
        },
      },
      new_notes_location = "current_dir",
      attachments = {
        confirm_img_paste = false,
        folder = "./attachments",
      },
      completion = {
        min_chars = 2,
      },
      picker = {
        name = "snacks.picker",
      },
      legacy_commands = false,
      ui = {
        enabled = false,
      },
      checkbox = {
        order = { " ", "x" },
      },
    },
  },
  {
    "bullets-vim/bullets.vim",
    init = function()
      vim.g.bullets_outline_levels = { "ROM", "ABC", "num", "abc", "rom", "std-" }
      vim.g.bullets_checkbox_markers = " ox"
      vim.g.bullets_enabled_file_types = { "markdown", "text", "typst" }
      vim.g.bullets_set_mappings = 0
      vim.g.bullets_custom_mappings = {
        { "imap", "<cr>", "<Plug>(bullets-newline)" },
        { "inoremap", "<C-cr>", "<cr>" },

        { "nmap", "o", "<Plug>(bullets-newline)" },

        { "vmap", "gN", "<Plug>(bullets-renumber)" },
        { "nmap", "gN", "<Plug>(bullets-renumber)" },

        { "nmap", "<leader>x", "<Plug>(bullets-toggle-checkbox)" },

        { "imap", "<C-t>", "<Plug>(bullets-demote)" },
        -- { 'nmap', '>>', '<Plug>(bullets-demote)' },
        -- { 'vmap', '>', '<Plug>(bullets-demote)' },
        { "imap", "<C-d>", "<Plug>(bullets-promote)" },
        -- { 'nmap', '<<', '<Plug>(bullets-promote)' },
        -- { 'vmap', '<', '<Plug>(bullets-promote)' },
      }
    end,
  },
  {
    "jmbuhr/otter.nvim",
    opts = {
      buffers = {
        set_filetype = true,
        write_to_disk = true,
      },
      handle_leading_whitespace = true,
    },
    version = "*",
    ft = { "markdown" },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          require("which-key").add({ "<localleader>o", buffer = 0, group = "Otter" })
          vim.keymap.set("n", "<localleader>oa", function()
            require("otter").activate()
          end, { desc = "Activate otter", buffer = 0 })
          vim.keymap.set("n", "<localleader>od", function()
            require("otter").deactivate()
          end, { desc = "Deactivate otter", buffer = 0 })
        end,
      })
    end,
  },
  {
    "dhruvasagar/vim-table-mode",
    init = function()
      vim.g.table_mode_map_prefix = "<localleader>t"
    end,
    ft = { "markdown" },
  },
  {
    "OXY2DEV/markview.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      local presets = require("markview.presets")
      return {
        highlight_groups = {
          MarkviewCode = { bg = "#3B4252" },
          MarkviewCodeFg = { fg = "#3B4252" },
          MarkviewCodeInfo = { bg = "#3B4252", fg = "#616E88" },
          MarkviewInlineCode = { bg = "#3B4252" },
          MarkviewIcon0 = { bg = "#3B4252", fg = "#606E87" },
          MarkviewIcon1 = { bg = "#3B4252", fg = "#87C0CF" },
          MarkviewIcon2 = { bg = "#3B4252", fg = "#87C0CF" },
          MarkviewIcon3 = { bg = "#3B4252", fg = "#87C0CF" },
          MarkviewIcon4 = { bg = "#3B4252", fg = "#87C0CF" },
          MarkviewIcon5 = { bg = "#3B4252", fg = "#87C0CF" },
        },
        preview = {
          modes = { "n", "no", "c", "i" },
          hybrid_modes = { "n", "i" },
          filetypes = { "codecompanion", "markdown", "python" },
          ignore_buftypes = {},
        },
        markdown = {
          list_items = {
            shift_width = function(buffer, item)
              --- Reduces the `indent` by 1 level.
              ---
              ---         indent                      1
              --- ------------------------- = 1 ÷ --------- = new_indent
              --- indent * (1 / new_indent)       new_indent
              ---
              local parent_indnet = math.max(1, item.indent - vim.bo[buffer].shiftwidth)

              return item.indent * (1 / (parent_indnet * 2))
            end,
            marker_minus = {
              add_padding = function(_, item)
                return item.indent > 1
              end,
            },
          },
          horizontal_rules = {
            parts = {
              {
                type = "repeating",
                direction = "left",

                repeat_amount = function(buffer)
                  local utils = require("markview.utils")
                  local window = utils.buf_getwin(buffer)

                  local width = vim.api.nvim_win_get_width(window)
                  local textoff = vim.fn.getwininfo(window)[1].textoff

                  return math.floor((width - textoff - 3) / 2)
                end,

                text = "─",

                hl = {
                  "MarkviewGradient1",
                  "MarkviewGradient1",
                  "MarkviewGradient2",
                  "MarkviewGradient2",
                  "MarkviewGradient3",
                  "MarkviewGradient3",
                  "MarkviewGradient4",
                  "MarkviewGradient4",
                  "MarkviewGradient5",
                  "MarkviewGradient5",
                  "MarkviewGradient6",
                  "MarkviewGradient6",
                  "MarkviewGradient7",
                  "MarkviewGradient7",
                  "MarkviewGradient8",
                  "MarkviewGradient8",
                  "MarkviewGradient9",
                  "MarkviewGradient9",
                },
              },
              {
                type = "text",

                text = "─",
                hl = "MarkviewIcon3Fg",
              },
              {
                type = "repeating",
                direction = "right",

                repeat_amount = function(buffer) --[[@as function]]
                  local utils = require("markview.utils")
                  local window = utils.buf_getwin(buffer)

                  local width = vim.api.nvim_win_get_width(window)
                  local textoff = vim.fn.getwininfo(window)[1].textoff

                  return math.ceil((width - textoff - 3) / 2)
                end,

                text = "─",
                hl = {
                  "MarkviewGradient1",
                  "MarkviewGradient1",
                  "MarkviewGradient2",
                  "MarkviewGradient2",
                  "MarkviewGradient3",
                  "MarkviewGradient3",
                  "MarkviewGradient4",
                  "MarkviewGradient4",
                  "MarkviewGradient5",
                  "MarkviewGradient5",
                  "MarkviewGradient6",
                  "MarkviewGradient6",
                  "MarkviewGradient7",
                  "MarkviewGradient7",
                  "MarkviewGradient8",
                  "MarkviewGradient8",
                  "MarkviewGradient9",
                  "MarkviewGradient9",
                },
              },
            },
          },
          headings = presets.headings.glow,
          block_quotes = presets.block_quotes.obsidian,
        },
        markdown_inline = {
          highlights = {
            default = {
              hl = "MarkviewPalette5",
            },
          },
          tags = {
            default = {
              hl = "MarkviewCodeInfo",
              padding_left = "",
              padding_left_hl = "MarkviewCodeFg",
              padding_right = "",
              padding_right_hl = "MarkviewCodeFg",
            },
            enable = true,
          },
        },
        latex = {
          enable = (os.getenv("TERM") or ""):find("kitty") == nil,
        },
        html = {
          enable = false,
        },
      }
    end,
  },
}
