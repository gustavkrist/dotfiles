-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheRest` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
local opts = {
  on_attach = function(client, bufnr)
    require "lsp_signature".on_attach()
  end
} -- check the lspconfig documentation for a list of all possible options
require("lvim.lsp.manager").setup("jedi_language_server", opts)


lvim.lsp.diagnostics.virtual_text = false
