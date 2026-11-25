local M = {}

function M.in_rex()
  local block = vim.env.REX_BLOCK
  return block ~= nil and block ~= ""
end

local rex_picker = function(items, opts, on_choice)
  local rex_items = {}
  for i, item in ipairs(items) do
    local title
    if opts.format_item then
      title = opts.format_item(item)
    elseif type(item) == "string" then
      title = item
    else
      error("Non-string items must provide a format_item")
    end
    rex_items[i] = { id = i, title = title }
  end
  local cmd = { "rex", "do", "rex_ui_pick", "--args", "-" }
  local args = { items = rex_items }
  if opts.prompt then
    args.title = opts.prompt
  else
    args.title = "Pick one"
  end
  vim.system(
    cmd,
    { text = true, stdin = vim.json.encode(args) },
    vim.schedule_wrap(function(out)
      if out.code ~= 0 then
        vim.notify("Failed to run Rex picker:\n" .. out.stderr, vim.log.levels.ERROR, { title = "Rex" })
        return
      end
      local success, choice = pcall(function()
        return tonumber(vim.json.decode(out.stdout))
      end)
      on_choice(success and items[choice] or nil, success and choice or nil)
    end)
  )
end

function M.register_picker()
  vim.ui.select = rex_picker
end

local rex_ui_input = function(opts, on_confirm)
  local args = {}
  if opts.prompt then
    args.title = opts.prompt
  else
    args.title = "Input"
  end
  if opts.default then
    args.value = opts.default
  end
  local cmd = { "rex", "do", "rex_ui_input", "--args", "-" }
  vim.system(
    cmd,
    { text = true, stdin = vim.json.encode(args) },
    vim.schedule_wrap(function(out)
      if out.code ~= 0 then
        vim.notify("Failed to run Rex input:\n" .. out.stderr, vim.log.levels.ERROR, { title = "Rex" })
        return
      end
      local success, input = pcall(function()
        return vim.trim(vim.json.decode(out.stdout))
      end)
      on_confirm(success and input or nil)
    end)
  )
end

function M.register_input()
  vim.ui.input = rex_ui_input
end

---@param rex_cmd string[]
---@param opts? {}
function M.exec(rex_cmd, opts)
  local rex_prog = "rex"
  opts = opts or { text = true }
  local cmd = { rex_prog }
  cmd = vim.list_extend(cmd, rex_cmd)
  if vim.system and M.in_rex() then
    vim.system(cmd, opts, function(p)
      if p.code ~= 0 then
        vim.notify("Failed to run Rex cmd:\n" .. p.stderr, vim.log.levels.ERROR, { title = "Rex" })
      end
    end)
  end
end

function M.setup()
  local nav = {
    h = "left",
    j = "down",
    k = "up",
    l = "right",
  }

  ---@param dir "left" | "right" | "down" | "up"
  ---@return function(): nil
  local function navigate(dir)
    return function()
      local rex_prog = "rex"
      local win = vim.api.nvim_get_current_win()
      vim.cmd.wincmd(dir)
      local opts = { text = true }
      if vim.system and M.in_rex() and win == vim.api.nvim_get_current_win() then
        local pane_dir = nav[dir]
        vim.system({ rex_prog, "do", "pane.focus." .. pane_dir }, opts, function(p)
          if p.code ~= 0 then
            vim.notify(
              "Failed to move to pane " .. pane_dir .. "\n" .. p.stderr,
              vim.log.levels.ERROR,
              { title = "Rex" }
            )
          end
        end)
      end
    end
  end

  -- Move to window using the movement keys
  for key, dir in pairs(nav) do
    vim.keymap.set("n", "<C-" .. key .. ">", navigate(key), { desc = "Go to " .. dir .. " window" })
  end

  vim.env.SNACKS_GHOSTTY = "true"
end

return M
