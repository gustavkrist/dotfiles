return {
  {
    "scalameta/nvim-metals",
    config = function(self, opts)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(opts)
        end,
        group = nvim_metals_group,
      })
    end,
    opts = function()
      local metals_config = require("metals").bare_config()
      metals_config.init_options.statusBarProvider = "off"
      metals_config.capabilities = require("blink-cmp").get_lsp_capabilities()
      return metals_config
    end,
    ft = { "scala" },
    keys = {
      { "<localleader>h", function() require("metals").hover_worksheet() end, desc = "Hover worksheet", ft = "scala" },
    },
  },
}
