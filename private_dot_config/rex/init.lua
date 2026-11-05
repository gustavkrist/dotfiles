local mod = "ctrl+shift+"

rex.bind(mod .. "p", "client.palette.toggle")

rex.bind(mod .. "t", "client.tab.new")
rex.bind(mod .. "l", "client.tab.next")
rex.bind(mod .. "h", "client.tab.previous")
rex.bind(mod .. ",", "client.tab.move.backward")
rex.bind(mod .. ".", "client.tab.move.forward")

rex.bind(mod .. "s>n", "session.new")
rex.bind(mod .. "s>s", "session.switch")
rex.bind(mod .. "s>" .. mod .. "s", "session.switch")
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

rex.bind(mod .. "f", "client.find.open")
rex.bind(mod .. "=", "client.font.increase")
rex.bind(mod .. "9", "client.font.decrease")
rex.bind(mod .. "/", "client.sidebar.toggle")
rex.bind(mod .. ".", "client.sidebar.activity.toggle")

local splits = require("splits")
splits.bind("ctrl+l", "focus", "right")
splits.bind("ctrl+h", "focus", "left")
splits.bind("ctrl+j", "focus", "down")
splits.bind("ctrl+k", "focus", "up")
splits.bind("ctrl+right", "resize", "right")
splits.bind("ctrl+left", "resize", "left")
splits.bind("ctrl+down", "resize", "down")
splits.bind("ctrl+up", "resize", "up")

-- rex.bind("ctrl+l", function(ctx, ev)
--   rex.log("error", ctx)
--   rex.log("error", ev)
--   return true
-- end)

rex.bind(mod .. "r", "client.config.reload")
