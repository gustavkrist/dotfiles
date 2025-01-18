return {
  {
    "gbprod/nord.nvim",
    config = function(_, opts)
      if vim.g.neovide ~= nil or require("util.firenvim")() then
        opts.transparent = false
      end
      require("nord").setup(opts)
      vim.cmd("colorscheme nord")
      vim.api.nvim_create_autocmd("Colorscheme", {
        pattern = { "nord" },
        callback = function()
          vim.cmd([[
            hi! link NoiceLspProgressTitle @comment
            hi! link LspInlayHint @comment
            hi NavicSeparator guibg=NONE
            ]])
          if not require("util.firenvim")() then
            require("util.wezterm").set_term_background("#D8DEE9", "#2E3440", "#D8DEE9")
          end
          if require("util.plugins").has("lualine.nvim") then
            require("util.lualine").load_lualine_custom_nord()
          end
        end,
      })
      require("util.plugins").on_very_lazy(function() vim.cmd("colorscheme nord") end)
    end,
    opts = {
      transparent = true,
      styles = {
        comments = { italic = false },
      },
    },
    priority = 1000,
  },
  {
    "folke/tokyonight.nvim",
    config = function(_, opts)
      if vim.g.neovide ~= nil or require("util.firenvim")() then
        opts.transparent = false
      end
      require("tokyonight").setup(opts)
      vim.api.nvim_create_autocmd("Colorscheme", {
        pattern = { "tokyonight" },
        callback = function()
          vim.cmd([[
            hi! link NoiceLspProgressTitle @comment
            hi NavicSeparator guibg=NONE
            ]])
          require("util.wezterm").set_term_background("#c0caf5", "#24283b", "#c0caf5")
          if require("util.plugins").has("lualine.nvim") then
            require("util.lualine").load_template("tokyonight")
          end
        end,
      })
    end,
    opts = {
      transparent = true,
    },
    lazy = true,
  },
  {
    "widatama/vim-phoenix",
    init = function()
      vim.api.nvim_create_autocmd("Colorscheme", {
        pattern = { "phoenix" },
        callback = function()
          vim.cmd([[
            hi Normal guibg=NONE
            hi! link NoiceLspProgressTitle @comment
            hi NavicSeparator guibg=NONE
            ]])
          require("util.wezterm").set_term_background("#CCCCCC", "#191919", "#EFEFEF")
        end,
      })
    end,
    lazy = true,
  },
  {
    "kxzk/skull-vim",
    init = function()
      vim.api.nvim_create_autocmd("Colorscheme", {
        pattern = { "skull" },
        callback = function()
          vim.cmd([[
            hi Normal guibg=NONE
            hi! link NoiceLspProgressTitle @comment
            hi NavicSeparator guibg=NONE
            ]])
          require("util.wezterm").set_term_background("#CCCCCC", "#222222", "#A0A0A0")
        end,
      })
    end,
    lazy = true,
  },
  {
    "kvrohit/rasmus.nvim",
    init = function()
      vim.g.rasmus_transparent = true
      -- vim.g.rasmus_variant = "monochrome"
      vim.api.nvim_create_autocmd("Colorscheme", {
        pattern = { "rasmus" },
        callback = function()
          vim.cmd([[
            hi! link NoiceLspProgressTitle @comment
            hi NavicSeparator guibg=NONE
            ]])
          require("util.wezterm").set_term_background("#d1d1d1", "#1a1a19", "#7bb099")
        end,
      })
    end,
    lazy = true,
  },
  {
    "wnkz/monoglow.nvim",
    opts = {
      on_colors = function(colors)
        colors.bg = "NONE"
      end
    },
    init = function()
      vim.api.nvim_create_autocmd("Colorscheme", {
        pattern = { "monoglow" },
        callback = function()
          vim.cmd([[
            hi! link NoiceLspProgressTitle @comment
            hi NavicSeparator guibg=NONE
            ]])
          require("util.wezterm").set_term_background("#c0c0c0", "#1c1c1c", "#bdfe58")
          if require("util.plugins").has("lualine.nvim") then
            require("util.lualine").load_template("monoglow", true, false)
          end
        end,
      })
    end,
    lazy = true,
  }
}
