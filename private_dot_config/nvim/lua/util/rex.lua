local M = {}

local function in_rex()
  local session = vim.env.REX_SESSION
  local block = vim.env.REX_BLOCK
  return session ~= nil and session ~= '' and block ~= nil and block ~= ''
end

function M.setup()
  local nav = {
    h = "left",
    j = "down",
    k = "up",
    l = "right",
  }

  local function navigate(dir)
    return function()
      local win = vim.api.nvim_get_current_win()
      vim.cmd.wincmd(dir)
      local rex_prog = "rex"
      local opts = { text = true }
      if vim.system and in_rex() and win == vim.api.nvim_get_current_win() then
        local pane_dir = nav[dir]
        vim.system({ rex_prog, "do", "pane.focus", "direction=" .. pane_dir }, opts, function(p)
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
    vim.keymap.set("n", "<" .. dir .. ">", navigate(key), { desc = "Go to " .. dir .. " window" })
    vim.keymap.set("n", "<C-" .. key .. ">", navigate(key), { desc = "Go to " .. dir .. " window" })
  end
end

return M
