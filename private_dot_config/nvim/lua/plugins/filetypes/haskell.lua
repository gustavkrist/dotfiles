return {
  {
    "mrcjkb/haskell-tools.nvim",
    version = "^6",
    lazy = false,
    keys = function()
      local ht = require("haskell-tools")
      return {
        { "<localleader>hs", ht.hoogle.hoogle_signature, desc = "Hoogle Signature", ft = "haskell" },
        { "<localleader>ea", ht.lsp.buf_eval_all, desc = "Eval all", ft = "haskell" },
        { "<localleader>rr", ht.repl.toggle, desc = "Toggle REPL (package)", ft = "haskell" },
        {
          "<localleader>rf",
          function()
            ht.repl.toggle(vim.api.nvim_buf_get_name(0))
          end,
          desc = "Toggle REPL (file)",
          ft = "haskell",
        },
        { "<localleader>rq", ht.repl.quit, desc = "Quit REPL", ft = "haskell" },
      }
    end,
  },
}
