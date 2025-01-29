return {
  {
    "alker0/chezmoi.vim",
    firenvim = false,
    lazy = false,
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = true
    end,
  },
}
