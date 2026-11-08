local M = {}

function M.in_rex()
  local session = vim.env.REX_SESSION
  local block = vim.env.REX_BLOCK
  return session ~= nil and session ~= "" and block ~= nil and block ~= ""
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
        vim.system({ rex_prog, "do", "pane.focus.".. pane_dir }, opts, function(p)
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
