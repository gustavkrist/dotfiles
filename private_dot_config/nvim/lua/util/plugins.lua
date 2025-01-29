-- From LazyVim
local M = {}

function M.is_loaded(name)
  local Config = require("lazy.core.config")
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  if M.is_loaded(name) then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

---@param name string
function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

---@param name string
---@param path string?
function M.get_plugin_path(name, path)
  local plugin = M.get_plugin(name)
  path = path and "/" .. path or ""
  return plugin and (plugin.dir .. path)
end

---@param plugin string
function M.has(plugin)
  return M.get_plugin(plugin) ~= nil
end

function M.should_enable_cond(spec)
  local enabled_cond = true
  if spec.cond ~= nil then
    if type(spec.cond) == "function" then
      enabled_cond = spec.cond()
    else
      enabled_cond = spec.cond
    end
  end
  if not enabled_cond then
    return false
  else
    if vim.g.started_by_firenvim then
      return spec.firenvim == nil and true or spec.firenvim
    elseif vim.g.vscode == 1 then
      return spec.vscode ~= nil and spec.vscode or false
    else
      return true
    end
  end
end

return M
