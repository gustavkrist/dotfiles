local mod = "ctrl+shift+"

-- Plugins
local fingers_bin = os.getenv("HOME") .. "/.config/rex/plugins/rex-fingers/bin/rex-fingers"
local fingers = require("plugins.rex-fingers.lua.rex-fingers")
fingers.setup{
  binary = fingers_bin,
  key = mod .. "space",
  window_key = mod .. "alt+space",
  overlay = "pane",
  flash = true,
  follow_scroll = false,
}

require("actions")

rex.bind(mod .. "p", "client.palette.toggle")

rex.bind(mod .. "t", "client.tab.new")
rex.bind(mod .. "l", "client.tab.next")
rex.bind(mod .. "h", "client.tab.previous")
rex.bind(mod .. ",", "client.tab.move.backward")
rex.bind(mod .. ".", "client.tab.move.forward")
rex.bind(mod .. "i", "client.navigate.forward")
rex.bind(mod .. "o", "client.navigate.back")

rex.bind(mod .. "s>n", "session.new")
rex.bind(mod .. "s>c", "session.collapse_others")
rex.bind(mod .. "s>s", "session_switch_collapse")
rex.bind(mod .. "s>" .. mod .. "s", "session_switch_collapse")
rex.bind(mod .. "s>r", "session.rename")
rex.bind(mod .. "s>" .. mod .. "r", "session.rename")
rex.bind(mod .. "s>x", "session.close")

rex.bind(mod .. "enter", "pane.split.auto")
rex.bind(mod .. "-", "pane.split.down")
rex.bind(mod .. "\\", "pane.split.right")
rex.bind(mod .. "m", "pane.zoom")
rex.bind(mod .. "c", "pane.copy")
rex.bind(mod .. "v", "pane.paste")
rex.bind(mod .. "j", "client.scroll.page_down")
rex.bind(mod .. "k", "client.scroll.page_up")
rex.bind(mod .. "g", "scroll_bottom")

rex.bind(mod .. "/", "client.find.open")
rex.bind(mod .. "=", "client.font.increase")
rex.bind(mod .. "9", "client.font.decrease")
rex.bind(mod .. "b", "client.tab_style.toggle")
rex.bind(mod .. "e", "client.sidebar.toggle")
rex.bind(mod .. "a", "client.sidebar.activity.toggle")

require("scratch-pad")
local splits = require("splits")

splits.bind("ctrl+l", "focus", "right")
splits.bind("ctrl+h", "focus", "left")
splits.bind("ctrl+j", "focus", "down")
splits.bind("ctrl+k", "focus", "up")
splits.bind("ctrl+right", "resize", "right")
splits.bind("ctrl+left", "resize", "left")
splits.bind("ctrl+down", "resize", "down")
splits.bind("ctrl+up", "resize", "up")
rex.bind(mod .. "left", "pane.move.left")
rex.bind(mod .. "right", "pane.move.right")
rex.bind(mod .. "up", "pane.move.up")
rex.bind(mod .. "down", "pane.move.down")
rex.bind(mod .. "q", "pane.close")
rex.bind(mod .. "'", "scratch_pad_toggle")

rex.bind(mod .. "x", "pane.copy_mode.enter")
rex.bind("copy/shift+y", "pane.copy_mode.copy_to_line_end")

rex.bind(mod .. "f>t", "pane.float")
rex.bind(mod .. "f>" .. mod .. "t", "pane.float")
rex.bind(mod .. "f>f", "pane.minimize_floating")
rex.bind(mod .. "f>" .. mod .. "f", "pane.minimize_floating")
rex.bind(mod .. "f>c", "center_floating_pane")

rex.bind(mod .. "r", "client.config.reload")

-- require("rex-typst").setup({ center = true })
-- rex.bind(mod .. "space>t", "typst_toggle")
require("ui")
