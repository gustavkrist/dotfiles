return {
  {
    "p00f/clangd_extensions.nvim",
    ft = { "cpp" },
    keys = {
      { "<localleader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)", ft = { "cpp" } },
    },
  },
}
