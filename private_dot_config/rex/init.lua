local mod = "ctrl+shift+"

rex.bind(mod .. "p", "client.palette.toggle")

rex.bind(mod .. "t", "client.tab.new")
rex.bind(mod .. "l", "client.tab.next")
rex.bind(mod .. "h", "client.tab.previous")
rex.bind(mod .. ",", "client.tab.move.backward")
rex.bind(mod .. ".", "client.tab.move.forward")

local function selected_session_pref()
  local result = rex.exec(
    { "/usr/bin/defaults", "read", "com.superlogical.rex", "Workspace.lastFocusedSession" },
    { timeout = 2 }
  )
  if result == nil or not result.ok then
    return nil
  end
  return (result.stdout:gsub("%s+$", ""))
end

rex.action({
  name = "session_switch_collapse",
  title = "Change Session and Collapse Others",
  description = "Open the session switcher, wait for a session to be chosen, then fold every other session.",
  run = function(ctx, args)
    if ctx.client_id == nil then
      error("Run this action from Rex, not the command line", 0)
    end
    --
    local before = selected_session_pref()
    if before == nil then
      -- The app's preference isn't readable here, which happens on a remote
      -- host. Fall back to opening the switcher alone.
      rex.client.queue("session.switch")
      return
    end

    -- The app answers as soon as it presents the switcher, so watch its
    -- recorded selection instead of waiting on the action itself.
    local performed, err = rex.call("client.perform", {
      client_id = ctx.client_id,
      action = "session.switch",
      origin = "key",
      timeout_ms = 10000,
    })
    if performed == nil then
      error(err, 0)
    end

    local poll = table.concat({
      "before=$1",
      "for _ in $(seq 1 110); do",
      '  now=$(/usr/bin/defaults read com.superlogical.rex "Workspace.lastFocusedSession" 2>/dev/null) || exit 2',
      '  [ "$now" != "$before" ] && exit 0',
      "  /bin/sleep 0.2",
      "done",
      "exit 3",
    }, "\n")
    local result = rex.exec({ "/bin/sh", "-c", poll, "sh", before }, { timeout = 26 })
    if result ~= nil and result.ok then
      rex.client.queue("session.collapse_others")
    end
  end,
})

rex.bind(mod .. "s>n", "session.new")
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
