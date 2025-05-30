-- https://github.com/folke/dot/blob/master/config/wezterm/links.lua
local wezterm = require("wezterm")

local M = {}

function M.open_file_uri_in_nvim_split(window, pane, uri)
  local url = wezterm.url.parse(uri)
  if url.scheme == "file" then
    local line = uri:match("#(%d+)$")
    local opts = { domain = "CurrentPaneDomain", args = { "zsh", "-c", "nvim " .. url.file_path } }
    if line then
      opts.args[3] = opts.args[3] .. " +" .. line
    end
    local dim = pane:get_dimensions()
    if dim.pixel_height > dim.pixel_width then
      window:perform_action(wezterm.action.SplitVertical(opts), pane)
    else
      window:perform_action(wezterm.action.SplitHorizontal(opts), pane)
    end
    return true
  end
  return false
end

---@param config Config
function M.setup(config)
	config.hyperlink_rules = {
		-- Linkify things that look like URLs and the host has a TLD name.
		--
		-- Compiled-in default. Used if you don't specify any hyperlink_rules.
		{
			regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b",
			format = "$0",
		},

		-- linkify email addresses
		-- Compiled-in default. Used if you don't specify any hyperlink_rules.
		{
			regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
			format = "mailto:$0",
		},

		-- file:// URI
		-- Compiled-in default. Used if you don't specify any hyperlink_rules.
		{
			regex = [[\bfile://\S*\b]],
			format = "$0",
		},

		-- Linkify things that look like URLs with numeric addresses as hosts.
		-- E.g. http://127.0.0.1:8000 for a local development server,
		-- or http://192.168.1.1 for the web interface of many routers.
		{
			regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
			format = "$0",
		},

		-- Make username/project paths clickable. This implies paths like the following are for GitHub.
		-- As long as a full URL hyperlink regex exists above this it should not match a full URL to
		-- GitHub or GitLab / BitBucket (i.e. https://gitlab.com/user/project.git is still a whole clickable URL)
		{
			regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
			format = "https://www.github.com/$1/$3",
		},
	}
end

return M
