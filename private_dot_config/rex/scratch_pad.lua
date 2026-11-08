local SCRATCH_LABEL = "scratch"
local SCRATCH_FLAVOR = "com.superlogical.terminal.shell"
local TMUX_PREFIX = "rex-scratch-"

-- Centered in the window, covering 90% of its width and height.
local SCRATCH_BOUNDS = { 0.05, 0.05, 0.9, 0.9 }

local tmux_path = nil

-- Find the scratch block in any layer, preferring a match in the given window.
-- The scratch pane is unique to the session rather than to a window.
local function find_scratch(view, window_id)
  local fallback = nil

  for _, window in ipairs(view.windows or {}) do
    local layers = window.layers or {}
    -- Layers are listed back to front, so search from the front.
    for i = #layers, 1, -1 do
      local layer = layers[i]
      for _, block in ipairs(layer.blocks or {}) do
        if block.label == SCRATCH_LABEL then
          local found = { window = window, layer = layer, block = block }
          if window.window_id == window_id then
            return found
          end
          fallback = fallback or found
        end
      end
    end
  end

  return fallback
end

-- Pick the window that holds the block the action ran in, falling back to the
-- active window.
local function window_for_block(view, block_id)
  local windows = view.windows or {}

  if block_id ~= nil then
    for _, window in ipairs(windows) do
      for _, layer in ipairs(window.layers or {}) do
        for _, block in ipairs(layer.blocks or {}) do
          if block.block_id == block_id then
            return window
          end
        end
      end
    end
  end

  for _, window in ipairs(windows) do
    if window.window_id == view.active_window_id then
      return window
    end
  end

  return nil
end

-- Pick a block in the window's tiled layout to move the scratch pane beside.
-- A floating anchor would place the scratch block inside its floating layer.
local function tiled_block(window, preferred_block_id)
  local fallback = nil

  for _, layer in ipairs(window.layers or {}) do
    if layer.kind == "tiled" then
      local blocks = layer.blocks or {}
      for _, block in ipairs(blocks) do
        if block.block_id == preferred_block_id then
          return block.block_id
        end
      end
      for _, block in ipairs(blocks) do
        if block.block_id == window.focused_block_id then
          return block.block_id
        end
      end
      if blocks[1] ~= nil then
        fallback = fallback or blocks[1].block_id
      end
    end
  end

  return fallback
end

local function set_layer_state(layer_id, state, focus)
  local args = { layer_id = layer_id, state = state }
  if focus then
    args.focus = true
  end

  local result, err = rex.session.set_layer_state(args)
  if result == nil then
    error(err, 0)
  end
end

-- Move the scratch block into the window and float it there again. Moving the
-- block keeps its program, and with it the tmux client attached to the shell.
local function move_scratch_to_window(scratch, anchor_block_id)
  local block_id = scratch.block.block_id

  local moved, move_err = rex.session.move_block({
    block_id = block_id,
    anchor_block_id = anchor_block_id,
    direction = "horizontal",
    side = "after",
  })
  if moved == nil then
    error(move_err, 0)
  end

  local floated, float_err = rex.session.float_block({
    block_id = block_id,
    bounds = SCRATCH_BOUNDS,
  })
  if floated == nil then
    error(float_err, 0)
  end

  set_layer_state(floated.layer_id, "normal", true)
  return floated.layer_id
end

-- Resolve the tmux program to an absolute path, since the terminal starts the
-- command directly, without a shell to set up PATH.
local function find_tmux()
  if tmux_path ~= nil then
    return tmux_path
  end

  for _, path in ipairs({ "/opt/homebrew/bin/tmux", "/usr/local/bin/tmux", "/usr/bin/tmux", "/bin/tmux" }) do
    local result = rex.exec({ path, "-V" }, { timeout = 2 })
    if result ~= nil and result.ok then
      tmux_path = path
      return path
    end
  end

  local result = rex.exec({ "/bin/sh", "-c", "command -v tmux" }, { timeout = 2 })
  if result ~= nil and result.ok then
    local path = result.stdout:gsub("%s+$", "")
    if path ~= "" then
      tmux_path = path
      return path
    end
  end

  return nil
end

local function tmux_session_name(view)
  local session_id = view.session_id or ""
  return TMUX_PREFIX .. (session_id:gsub("^session:", ""))
end

local function create_scratch(view, window)
  local session_name = tmux_session_name(view)
  if session_name == TMUX_PREFIX then
    error("Cannot determine the session ID for the scratch pane", 0)
  end

  local tmux = find_tmux()
  if tmux == nil then
    error("The scratch pane needs tmux, but tmux was not found on this host", 0)
  end

  local result, err = rex.session.new_layer({
    window_id = window.window_id,
    bounds = SCRATCH_BOUNDS,
    layout = {
      block = {
        flavor = SCRATCH_FLAVOR,
        label = SCRATCH_LABEL,
        options = {
          command = { tmux, "new-session", "-A", "-s", session_name },
          shell = "none",
        },
      },
    },
    focus = true,
  })
  if result == nil then
    error(err, 0)
  end

  return { layer_id = result.layer_id, block_id = result.block_ids[1], visible = true, created = true }
end

rex.action({
  name = "scratch_pad_toggle",
  title = "Toggle Scratch Pad",
  description = "Show or hide a tmux-backed floating scratch terminal, closing the pane when hidden and bringing it into the current tab.",
  keywords = "scratch pad floating terminal tmux toggle",
  run = function(ctx, args)
    local view, err = rex.session.view({})
    if view == nil then
      error(err, 0)
    end

    local window = window_for_block(view, ctx.block_id)
    if window == nil then
      error("Cannot open the scratch pane: the session has no window", 0)
    end

    local scratch = find_scratch(view, window.window_id)

    if scratch == nil then
      return create_scratch(view, window)
    end

    if scratch.window.window_id ~= window.window_id then
      -- The scratch pane lives in another tab: bring it here and focus it.
      local anchor_block_id = tiled_block(window, ctx.block_id)
      if anchor_block_id == nil then
        error("Cannot move the scratch pane into this window: it has no tiled pane", 0)
      end

      local layer_id = move_scratch_to_window(scratch, anchor_block_id)
      return { layer_id = layer_id, block_id = scratch.block.block_id, visible = true, created = false, moved = true }
    end

    if scratch.layer.kind == "floating" and scratch.layer.state == "minimized" then
      set_layer_state(scratch.layer.layer_id, "normal", true)
      return { layer_id = scratch.layer.layer_id, block_id = scratch.block.block_id, visible = true, created = false }
    end

    if scratch.layer.kind == "tiled" then
      -- The pane was taken out of its floating layer: float it again.
      local floated, float_err = rex.session.float_block({
        block_id = scratch.block.block_id,
        bounds = SCRATCH_BOUNDS,
      })
      if floated == nil then
        error(float_err, 0)
      end
      set_layer_state(floated.layer_id, "normal", true)
      return { layer_id = floated.layer_id, block_id = scratch.block.block_id, visible = true, created = false }
    end

    -- Hide the scratch pane. The tmux session keeps the shell and scrollback.
    local result, close_err = rex.call("block.close", {
      session_id = view.session_id,
      block_id = scratch.block.block_id,
    })
    if result == nil then
      error(close_err, 0)
    end

    return { block_id = scratch.block.block_id, visible = false, created = false }
  end,
})
