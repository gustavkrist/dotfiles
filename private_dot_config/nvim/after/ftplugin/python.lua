vim.opt.formatoptions:append("r")

vim.b.slime_cell_delimiter = "^# %%"

local function toggle_basedpyright_settings()
  local client = vim.lsp.get_clients({ name = "basedpyright" })[1]
  if not client then
    vim.notify("basedpyright LSP is not active", vim.log.levels.WARN)
    return
  end

  -- Toggle typeCheckingMode
  local config = client.config
  local analysis = config.settings.basedpyright.analysis
  if analysis.typeCheckingMode == "basic" then
    analysis.typeCheckingMode = "recommended"
  else
    analysis.typeCheckingMode = "basic"
  end

  client:notify("workspace/didChangeConfiguration", { setting = nil })
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("basedpyright_toggle", { clear = true }),
  pattern = "python",
  callback = function(ev)
    vim.keymap.set(
      "n",
      "<localleader>up",
      toggle_basedpyright_settings,
      { desc = "Toggle BasedPyright Type Checking", buffer = ev.buf }
    )
  end,
})
