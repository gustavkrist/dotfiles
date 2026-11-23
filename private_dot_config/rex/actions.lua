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

local function layer_has_block(layer, block_id)
  for _, block in ipairs(layer.blocks or {}) do
    if block.block_id == block_id then
      return true
    end
  end
  return false
end

local function is_visible_floating(layer)
  return layer.kind == "floating" and layer.state ~= "minimized"
end

local function floating_layer_for(view, block_id)
  local windows = view.windows or {}

  -- Use the window that holds the block, or the active window when the block isn't known.
  local window = nil
  if block_id ~= nil then
    for _, candidate in ipairs(windows) do
      for _, layer in ipairs(candidate.layers or {}) do
        if layer_has_block(layer, block_id) then
          window = candidate
          break
        end
      end
      if window ~= nil then
        break
      end
    end
  end
  if window == nil then
    for _, candidate in ipairs(windows) do
      if candidate.window_id == view.active_window_id then
        window = candidate
        break
      end
    end
  end
  if window == nil then
    return nil
  end

  local layers = window.layers or {}

  -- Prefer the floating layer that holds the focused block.
  if block_id ~= nil then
    for _, layer in ipairs(layers) do
      if is_visible_floating(layer) and layer_has_block(layer, block_id) then
        return layer
      end
    end
  end

  -- Otherwise center the frontmost visible floating layer.
  for i = #layers, 1, -1 do
    if is_visible_floating(layers[i]) then
      return layers[i]
    end
  end
  return nil
end

rex.action({
  name = "center_floating_pane",
  title = "Center Floating Pane",
  description = "Move the floating pane to the center of its window without resizing it.",
  keywords = "float layer window position",
  run = function(ctx, args)
    local view, err = rex.session.view({})
    if view == nil then
      error(err, 0)
    end

    local layer = floating_layer_for(view, ctx.block_id)
    if layer == nil or layer.bounds == nil or #layer.bounds < 4 then
      return nil
    end

    local w, h = layer.bounds[3], layer.bounds[4]
    if w <= 0 or h <= 0 then
      return nil
    end

    local bounds = { (1 - w) / 2, (1 - h) / 2, w, h }
    local result, resize_err = rex.session.resize_layer({
      layer_id = layer.layer_id,
      bounds = bounds,
    })
    if result == nil then
      error(resize_err, 0)
    end

    return { layer_id = layer.layer_id, bounds = bounds }
  end,
})

local function shell_quote(value)
  return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

rex.action({
  name = "open_scrollback",
  title = "Open Scrollback in NVIM",
  description = "Open the terminal scrollback in a read-only Neovim window",
  run = function(ctx, args)
    if ctx.session_id == nil or ctx.block_id == nil then
      error("Run this action from a terminal block", 0)
    end

    -- The terminal block runs an argv, not a shell, so wrap the capture and
    -- Neovim in sh to connect them with a pipe. --format=vt keeps the escape
    -- sequences; Neovim reads the result from stdin because of the final -.
    local command = table.concat({
      "rex capture",
      "-s " .. shell_quote(ctx.session_id),
      "-b " .. shell_quote(ctx.block_id),
      "--format=vt",
      "--trim",
      "--unwrap",
      [[| nvim -u NONE -R -M -c 'lua require("util.kitty").pager(100000, 100000, 100000)' -]],
    }, " ")

    local result, err = rex.session.new_layer({
      session_id = ctx.session_id,
      bounds = { 0, 0, 1, 1 },
      focus = true,
      layout = {
        block = {
          flavor = "com.superlogical.terminal.shell",
          options = {
            command = { "/bin/sh", "-c", command },
          },
        },
      },
    })
    if result == nil then
      error(err, 0)
    end
    return result
  end,
})

rex.action({
  name = "scroll_bottom",
  title = "Scroll to bottom of pane",
  description = "Spam scroll-down to reach bottom",
  run = function(ctx, args)
    for _ = 1, 100 do
      rex.client.queue("client.scroll.page_down")
    end
  end,
})
