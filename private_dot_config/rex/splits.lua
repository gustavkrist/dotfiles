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
  for _, ancestor in ipairs(proc.ancestors or {}) do
    if ancestor.name:match("^n?vim") then
      return true
    end
  end
  if not fg.pid then
    return false
  end
  local result = rex.exec({ 'ps', '-A', '-o', 'pid=', '-o', 'pgid=', '-o', 'state=', '-o', 'comm=' }, {
    timeout = 0.5,
  })
  if not result or not result.ok or result.timed_out then
    return false
  end
  local groups, editors = {}, {}
  for line in result.stdout:gmatch('[^\r\n]+') do
    local pid, group, state, command = line:match('^%s*(%d+)%s+(%d+)%s+(%S+)%s+(.+)$')
    if pid then
      group = tonumber(group)
      groups[tonumber(pid)] = group
      local name = command:gsub('%s+$', ''):match('([^/]+)$')
      if not state:match('^[TXZtxz]') and name:match("^n?vim") then
        editors[group] = true
      end
    end
  end
  return editors[groups[fg.pid]] == true
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
        rex.client.queue("pane.focus." .. args.dir)
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
  rex.bind(key, "smart_splits", { key = key, action = action, dir = dir })
end

return M
