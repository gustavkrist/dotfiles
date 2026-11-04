local M = {}

local function is_vim(ctx)
  if not ctx.block_id then
    return false
  end
  local proc = rex.block.call("com.superlogical.terminal", "process", { block_id = ctx.block_id })
  if not proc then
    return false
  end
  local fg = proc.foreground
  if not fg then
    return false
  end
  for _, name in ipairs({ fg.name or "", (fg.argv0 or ""):match("[^/]*$") }) do
    if name:match("^n?vim") then
      return true
    end
  end
  return false
end

rex.action({
  name = "smart_splits",
  title = "Smart Splits",
  args = {
    type = "object",
    required = { "key", "action", "dir" },
    properties = {
      key = { type = "string" },
      action = { type = "string", enum = { "focus", "resize" } },
      dir = { type = "string", enum = { "right", "left", "up", "down" } },
    },
  },
  run = function(ctx, args)
    if is_vim(ctx) then
      rex.client.queue("pane.send_key", { key = args.key })
    else
      if args.action == "focus" then
        rex.session.focus_direction({ direction = args.dir })
      elseif args.action == "resize" then
        rex.client.queue("pane.resize", { direction = args.dir, amount = 3 })
      end
    end
  end,
  repeats = true,
})

---@param key string
---@param action "resize" | "focus"
---@param dir "right" | "left" | "up" | "down"
function M.bind(key, action, dir)
  rex.bind(key, "smart_splits", { key=key, action=action, dir=dir })
end

return M
