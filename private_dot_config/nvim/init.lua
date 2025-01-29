if vim.fn.has("wsl") == 1 then
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
if vim.g.vscode == 1 then
  require("config.autocommands")
  require("config.vscode")
  require("config.lazy")
else
  require("config.options")
  require("config.keymap")
  require("config.autocommands")
  require("config.lsp")
  require("config.lazy")
  if vim.g.neovide then
    require("config.neovide")
  end
  if vim.g.started_by_firenvim ~= nil then
    require("config.firenvim")
  end
end
