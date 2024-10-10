return {
  {
    "alker0/chezmoi.vim",
    cond = function() return not require("util.firenvim").get() end,
    lazy = false,
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = true
    end
  },
}
