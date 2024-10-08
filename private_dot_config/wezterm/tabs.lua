-- https://github.com/folke/dot/blob/master/config/wezterm/tabs.lua
local wezterm = require("wezterm") --[[@as Wezterm]]
local M = {}

---@param config Config
function M.setup(config)
  config.use_fancy_tab_bar = true
  config.tab_bar_at_bottom = false
  config.hide_tab_bar_if_only_one_tab = wezterm.target_triple:find("windows") == nil
  config.tab_max_width = 32
  config.unzoom_on_switch_pane = true
end

return M
