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
      vim.g.mkdp_filetypes = { "markdown", "pandoc" }
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
    ft = { "markdown", "pandoc" },
  },
  {
    "obsidian-nvim/obsidian.nvim",
    ft = "markdown",
    config = function(_, opts)
      local function paste_image()
        vim.ui.input({
          prompt = "Image name",
          default = string.format("pasted-image-%s", os.time()),
        }, function(input)
          local cur_dir = vim.api.nvim_buf_get_name(0):match("(.*)/")
          local path = vim.fs.joinpath(cur_dir, "attachments", input)
          vim.cmd(string.format("ObsidianPasteImg %s", path))
        end)
      end
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.keymap.set("n", "<localleader>ip", paste_image, { desc = "Paste image from clipboard", buffer = 0 })
        end,
      })
      require("obsidian").setup(opts)
    end,
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
            disable_frontmatter = true,
          },
        },
      },
      new_notes_location = "current_dir",
      ui = {
        enable = false,
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
        }
      },
      attachments = {
        confirm_img_paste = false,
        img_text_func = function(client, path)
          path = client:vault_relative_path(path) or path
          return string.format("![[%s]]", path.name)
        end,
      },
      completion = {
        blink = true,
        min_chars = 2,
      },
      picker = {
        name = "snacks.pick",
      },
    },
  },
  {
    "vim-pandoc/vim-pandoc",
    init = function()
      vim.g["pandoc#filetypes#pandoc_markdown"] = 0
      vim.g["pandoc#filetypes#handled"] = { "pandoc", "markdown" }
      vim.g["pandoc#folding#fold_yaml"] = 1
      vim.g["pandoc#folding#fold_fenced_codeblocks"] = 1
      vim.g["pandoc#folding#fastfolds"] = 1
      vim.g["pandoc#folding#fdc"] = 0
      -- vim.g["pandoc#modules#enabled"] = { "keyboard" }
      -- vim.g["pandoc#modules#disabled"] = { "formatting", "folding", "hypertext" }
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          -- vim.call("pandoc#command#Init")
          -- vim.call("pandoc#compiler#Init")
          -- vim.call("pandoc#folding#Init")
          -- vim.call("pandoc#keyboard#Init")
          -- vim.call("pandoc#formatting#Init")
          -- vim.call("pandoc#spell#Init")
          vim.call("pandoc#toc#Init")
          vim.call("pandoc#yaml#Init")
        end,
      })
    end,
  },
  {
    "bullets-vim/bullets.vim",
    init = function()
      vim.g.bullets_outline_levels = { "ROM", "ABC", "num", "abc", "rom", "std-" }
      vim.g.bullets_checkbox_markers = " ox"
    end,
    ft = "markdown",
  },
  {
    "jmbuhr/otter.nvim",
    opts = {},
    version = "*",
    ft = { "markdown" },
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
    opts = {
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
      preview = { hybrid_modes = { "n", "i" }, filetypes = { "codecompanion", "markdown" }, ignore_buftypes = {} },
      markdown = {
        list_items = {
          shift_width = function (buffer, item)
            --- Reduces the `indent` by 1 level.
            ---
            ---         indent                      1
            --- ------------------------- = 1 ÷ --------- = new_indent
            --- indent * (1 / new_indent)       new_indent
            ---
            local parent_indnet = math.max(1, item.indent - vim.bo[buffer].shiftwidth);

            return (item.indent) * (1 / (parent_indnet * 2));
          end,
          marker_minus = {
            add_padding = function (_, item)
              return item.indent > 1;
            end
          }
        }
      }
    },
    ft = { "codecompanion", "markdown" },
  },
}
