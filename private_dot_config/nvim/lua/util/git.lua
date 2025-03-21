---@class util.git
local M = {}

function M.get_session_name()
  local obj = vim.system({ "git", "rev-parse", "--show-toplevel", "--abbrev-ref", "HEAD" }, { text = true }):wait()
  if obj.code == 0 and obj.stdout then
    ---@type string[]
    local data = vim.split(obj.stdout, "\n")
    local git_root_path = data[1]
    local git_basename = string.match(git_root_path, "[^/]*$")
    local git_branch_name = string.gsub(data[2], "%s*$", "")
    local session_name = git_basename .. "-" .. string.gsub(git_branch_name, "/", "-")
    return session_name
  end
  return nil
end

local function git_branch_session_exists(name)
  for _, session in pairs(require("mini.sessions").detected) do
    if session.name == name then
      return true
    end
  end
  return false
end

function M.get_git_branch_session()
  local session_name = M.get_session_name()
  if session_name ~= nil then
    if git_branch_session_exists(session_name) then
      return session_name
    end
  end
  return nil
end

function M.set_git_session_global()
  ---@param obj vim.SystemCompleted
  local function set_mini_session(obj)
    if obj.code == 0 and obj.stdout then
      ---@type string[]
      local data = vim.split(obj.stdout, "\n")
      local git_root_path = data[1]
      local git_basename = string.match(git_root_path, "[^/]*$")
      local git_branch_name = string.gsub(data[2], "%s*$", "")
      local session_name = git_basename .. "-" .. string.gsub(git_branch_name, "/", "-")
      local session_exists = git_branch_session_exists(session_name)
      if session_exists then
        vim.g.git_session_name = session_name
        return
      end
    end
    vim.g.git_session_name = ""
  end
  vim.system({ "git", "rev-parse", "--show-toplevel", "--abbrev-ref", "HEAD" }, { text = true }, set_mini_session)
end

--- Open picker for branch/commit and run vim function `fn` with picked value as argument
---@param what "file" | "repo"
---@param mode string?
function M.gitbrowse_with_branch(what, mode)
  local start_pos, end_pos = nil, nil
  if mode == "v" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", false)
    start_pos = vim.api.nvim_buf_get_mark(0, "<")[1]
    end_pos = vim.api.nvim_buf_get_mark(0, ">")[1]
  end
  local branches = vim.split(
    vim.system({ "git", "rev-parse", "--abbrev-ref", "origin/HEAD", "HEAD" }, { text = true }):wait().stdout,
    "\n"
  )
  local default = vim.fs.basename(branches[1])
  local current = string.gsub(branches[2], "%s*$", "")
  local commit = vim.system({ "git", "log", "-n", "1", "--pretty=format:%H" }, { text = true }):wait().stdout
  vim.ui.select({
    { text = string.format("Current branch [%s]", current), value = current },
    { text = string.format("Default branch [%s]", default), value = default },
    { text = string.format("Last commit [%s]", commit), value = commit },
  }, {
    prompt = "Which branch to use?",
    format_item = function(item)
      return item.text
    end,
  }, function(choice)
    if choice ~= nil then
      ---@type snacks.gitbrowse.Config
      local config = { what = what, branch = choice.value }
      if mode == "v" then
        config.line_start = start_pos
        config.line_end = end_pos
      end
      require("snacks").gitbrowse.open(config)
    end
  end)
end

return M
