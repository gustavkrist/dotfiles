if vim.loop.os_uname().sysname == "Linux" then
  vim.g.vimtex_view_method = "general"
  vim.g.vimtex_view_general_viewer = "sumatrapdf"
  vim.g.R_pdfviewer = "zathura"
elseif vim.loop.os_uname().sysname == "Darwin" then
  vim.g.vimtex_view_method = "skim"
end

-- Faster clipboard for wsl
if vim.fn.has "wsl" == 1 then
  vim.g.clipboard = {
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
  }
end
