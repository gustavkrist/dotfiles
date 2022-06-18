lvim.plugins = {
  {
    'lervag/vimtex',
    ft = { "latex", "tex" },
    config = function()
      vim.g.vimtex_view_method = 'skim'
    end
  },
  { 'sainnhe/edge' },
  { 'joshdick/onedark.vim' },
  { 'arcticicestudio/nord-vim' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-repeat' },
  { 'christoomey/vim-tmux-navigator' },
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require('user.config.neoscroll').config()
    end
  },
  {
    "tzachar/cmp-tabnine",
    run = "./install.sh",
    requires = "hrsh7th/nvim-cmp",
    event = "InsertEnter",
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function()
      require "lsp_signature".setup()
    end
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    setup = function()
      require("user.config.indent_blankline").setup()
    end
  },
  {
    "ethanholz/nvim-lastplace",
    event = "BufRead",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = {
          "gitcommit", "gitrebase", "svn", "hgcommit",
        },
        lastplace_open_folds = true,
      })
    end,
  },
  {
    "felipec/vim-sanegx",
    event = "BufRead",
  },
  {
    'tpope/vim-obsession',
    cmd = "Obsession"
  },
  {
    'dbakker/vim-paragraph-motion'
  },
  {
    'michaeljsmith/vim-indent-object'
  },
  {
    'justinmk/vim-sneak'
  },
  {
    'rebelot/kanagawa.nvim'
  },
  {
    'vim-pandoc/vim-pandoc',
    requires = 'vim-pandoc/vim-pandoc-syntax',
    config = function()
      vim.cmd "let g:pandoc#syntax#codeblocks#embeds#langs=['R']"
    end,
    ft = "markdown"
  },
  {
    'coachshea/vim-textobj-markdown',
    requires = 'kana/vim-textobj-user',
    ft = { "markdown", "Rmd" }
  },
  {
    'urbainvaes/vim-ripple',
    event = "BufWinEnter",
    config = function()
      require("user.config.vim_ripple").config()
    end
  },
  {
    'jamespeapen/Nvim-R',
    ft = { "Rmd", "R" },
    config = function()
      require("user.config.nvim_r").config()
    end
  },
  {
    'edkolev/tmuxline.vim',
    event = "BufWinEnter"
  },
  {
    'wakatime/vim-wakatime',
    event = "BufWinEnter"
  },
  {
    "folke/lsp-colors.nvim",
    event = "BufRead",
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("user.config.colorizer").config()
    end,
    event = "BufWinEnter",
  },
  {
    "rmagatti/goto-preview",
    config = function()
      require('user.config.goto_preview').config()
    end,
    event = "BufWinEnter",
  },
  {
    "Pocco81/AutoSave.nvim",
    config = function()
      require("autosave").setup({
        conditions = {
          filename_is_not = { "config.lua" }
        },
        on_off_commands = true
      })
    end,
  },
  {
    "monaqa/dial.nvim",
    event = "BufWinEnter",
    config = function()
      require("user.config.dial").config()
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },
  {
    'simrat39/rust-tools.nvim',
    config = function()
      require("rust-tools").setup({
        hover_actions = {
          auto_focus = true,
        }
      })
      vim.cmd("nnoremap <C-_> <cmd>RustRun<CR>")
    end,
    ft = "rust"
  },
  {
    "hood/popui.nvim",
    requires = { "RishabhRD/popfix" }
  },
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function()
      require("user.config.mkdp").setup()
    end,
    ft = { "markdown", "pandoc" }
  }
}
