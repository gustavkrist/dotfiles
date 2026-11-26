local SCRATCH_LABEL = "scratch"
local SCRATCH_FLAVOR = "com.superlogical.terminal.shell"
local TERMINAL_CREATOR = "com.superlogical.terminal"

-- Centered in the window, covering 90% of its width and height.
local SCRATCH_BOUNDS = { 0.05, 0.05, 0.9, 0.9 }

-- Find the scratch block in any layer, preferring a match in the given window.
-- The scratch block is unique to the session rather than to a window.
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

-- Find the detached scratch block, which is hidden but still running. A
-- placement this call doesn't know counts as detached.
local function find_detached_scratch(session_id)
  local result, err = rex.session.list_blocks({ session_id = session_id })
  if result == nil then
    error(err, 0)
  end

  for _, block in ipairs(result.blocks or {}) do
    if block.label == SCRATCH_LABEL and block.placement ~= "placed" then
      return block
    end
  end

  return nil
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

-- Pick a block in the window's tiled layout to move the scratch block beside.
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

-- Float the block over the window and focus it.
local function float_scratch(block_id)
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

-- Put a block that is detached or in another window beside a tiled block here,
-- and float it there. Placing the block keeps its shell running.
local function place_scratch(window, block_id, preferred_block_id)
  local anchor_block_id = tiled_block(window, preferred_block_id)
  if anchor_block_id == nil or anchor_block_id == block_id then
    error("Cannot show the scratch block in this window: it has no other tiled pane", 0)
  end

  local moved, move_err = rex.session.move_block({
    block_id = block_id,
    anchor_block_id = anchor_block_id,
    direction = "horizontal",
    side = "after",
  })
  if moved == nil then
    error(move_err, 0)
  end

  return float_scratch(block_id)
end

-- pwd reports a file:// URL when the shell used OSC 7, and a plain path otherwise.
local function pwd_path(pwd)
  local path = pwd:match("^file://[^/]*(/.*)$")
  if path == nil then
    return pwd
  end

  return (path:gsub("%%(%x%x)", function(hex)
    return string.char(tonumber(hex, 16))
  end))
end

-- Read the working directory of the pane the action ran in, preferring the
-- foreground process over the directory the shell last reported.
local function pane_cwd(block_id)
  if block_id == nil then
    return nil
  end

  local process = rex.block.call(TERMINAL_CREATOR, "process", { block_id = block_id })
  if process ~= nil then
    local foreground = process.foreground or process.child
    if foreground ~= nil and foreground.cwd ~= nil and foreground.cwd ~= "" then
      return foreground.cwd
    end
  end

  local pwd = rex.block.call(TERMINAL_CREATOR, "pwd", { block_id = block_id })
  if pwd ~= nil and pwd.pwd ~= nil and pwd.pwd ~= "" then
    return pwd_path(pwd.pwd)
  end

  return nil
end

-- Whether the scratch block is the block the action ran in, or the block that
-- has focus in the active window.
local function scratch_focused(view, window, block_id, origin_block_id)
  if origin_block_id == block_id then
    return true
  end

  return view.active_window_id == window.window_id and window.focused_block_id == block_id
end

local function create_scratch(window, cwd)
  local options = {}
  if cwd ~= nil then
    options.cwd = cwd
  end

  local result, err = rex.session.new_layer({
    window_id = window.window_id,
    bounds = SCRATCH_BOUNDS,
    layout = {
      block = {
        flavor = SCRATCH_FLAVOR,
        label = SCRATCH_LABEL,
        options = options,
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
  description = "Show or hide a floating scratch terminal, which keeps its shell and scrollback while it is hidden.",
  keywords = "scratch pad floating terminal toggle",
  run = function(ctx, args)
    local view, err = rex.session.view({})
    if view == nil then
      error(err, 0)
    end

    local window = window_for_block(view, ctx.block_id)
    if window == nil then
      error("Cannot open the scratch block: the session has no window", 0)
    end

    local scratch = find_scratch(view, window.window_id)

    -- Hide the scratch block while it has focus. Detaching keeps the shell
    -- running, so it comes back with its scrollback.
    if scratch ~= nil and scratch_focused(view, window, scratch.block.block_id, ctx.block_id) then
      local detached, detach_err = rex.session.detach_block({ block_id = scratch.block.block_id })
      if detached == nil then
        error(detach_err, 0)
      end

      return { block_id = scratch.block.block_id, visible = false, created = false, detached = true }
    end

    if scratch == nil then
      local detached = find_detached_scratch(view.session_id)
      if detached ~= nil then
        local layer_id = place_scratch(window, detached.block_id, ctx.block_id)
        return {
          layer_id = layer_id,
          block_id = detached.block_id,
          visible = true,
          created = false,
          attached = true,
        }
      end

      return create_scratch(window, pane_cwd(ctx.block_id or window.focused_block_id))
    end

    if scratch.window.window_id ~= window.window_id then
      -- The scratch block lives in another tab: bring it here and focus it.
      local layer_id = place_scratch(window, scratch.block.block_id, ctx.block_id)
      return {
        layer_id = layer_id,
        block_id = scratch.block.block_id,
        visible = true,
        created = false,
        moved = true,
      }
    end

    if scratch.layer.kind == "tiled" then
      -- The block was taken out of its floating layer: float it again.
      local layer_id = float_scratch(scratch.block.block_id)
      return { layer_id = layer_id, block_id = scratch.block.block_id, visible = true, created = false }
    end

    -- The block is already floating here, so raise it and focus it.
    set_layer_state(scratch.layer.layer_id, "normal", true)
    return {
      layer_id = scratch.layer.layer_id,
      block_id = scratch.block.block_id,
      visible = true,
      created = false,
    }
  end,
})
