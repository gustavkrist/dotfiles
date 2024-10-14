return {
  {
    "ionide/Ionide-vim",
    cond = function()
      return not require("util.firenvim").get()
    end,
    init = function()
      vim.cmd("let g:fsharp#lsp_auto_setup = 0")
      vim.cmd("let g:fsharp#exclude_project_directories = ['paket-files']")
    end,
    ft = { "fsharp" },
  },
}
