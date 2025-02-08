local wezterm = require("wezterm") --[[@as Wezterm]]

local act = wezterm.action
local M = {}

-- Inspired (or copied) from https://github.com/folke/dot/blob/master/config/wezterm/keys.lua
-- M.mod = wezterm.target_triple:find("windows") and "SHIFT|CTRL" or "SHIFT|SUPER"
M.mod = "SHIFT|CTRL"

M.smart_split = wezterm.action_callback(function(window, pane)
	local dim = pane:get_dimensions()
	if dim.pixel_height > dim.pixel_width then
		window:perform_action(act.SplitVertical({ domain = "CurrentPaneDomain" }), pane)
	else
		window:perform_action(act.SplitHorizontal({ domain = "CurrentPaneDomain" }), pane)
	end
end)

---@param config Config
function M.setup(config)
	config.disable_default_key_bindings = true
	config.keys = {
		{ mods = M.mod, key = "p", action = act.ActivateCommandPalette },
		-- Scroll
		{ mods = M.mod, key = "k", action = act.ScrollByPage(-0.5) },
		{ mods = M.mod, key = "j", action = act.ScrollByPage(0.5) },
		{ mods = M.mod, key = "g", action = act.ScrollToBottom },
		-- New tab
		{ mods = M.mod, key = "t", action = act.SpawnTab("CurrentPaneDomain") },
		-- Splits
		{ mods = M.mod, key = "Enter", action = M.smart_split },
		{ mods = M.mod, key = "|", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ mods = M.mod, key = "_", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		-- Font size
		{ mods = M.mod, key = "(", action = act.DecreaseFontSize },
		{ mods = M.mod, key = "+", action = act.IncreaseFontSize },
		-- Move tabs
		{ mods = M.mod, key = ">", action = act.MoveTabRelative(1) },
		{ mods = M.mod, key = "<", action = act.MoveTabRelative(-1) },
		-- Acivate Tabs
		{ mods = M.mod, key = "l", action = act({ ActivateTabRelative = 1 }) },
		{ mods = M.mod, key = "h", action = act({ ActivateTabRelative = -1 }) },
		{ mods = M.mod, key = "r", action = wezterm.action.RotatePanes("Clockwise") },
		-- show the pane selection mode, but have it swap the active and selected panes
		{ mods = M.mod, key = "s", action = wezterm.action.PaneSelect({ show_pane_ids = true }) },
		-- Clipboard
		{ mods = M.mod, key = "c", action = act.CopyTo("Clipboard") },
		{ mods = "SUPER", key = "c", action = act.CopyTo("Clipboard") },
		{ mods = M.mod, key = "Space", action = act.QuickSelect },
		{ mods = M.mod, key = "x", action = act.ActivateCopyMode },
		{ mods = M.mod, key = "f", action = act.Search("CurrentSelectionOrEmptyString") },
		{ mods = M.mod, key = "v", action = act.PasteFrom("Clipboard") },
		{ mods = "SUPER", key = "v", action = act.PasteFrom("Clipboard") },
    {
      mods = M.mod,
      key = "o",
      action = act.QuickSelectArgs({
        patterns = {
          '^\\d+(?=:\\s)',
          '(?:[a-zA-Z-_]+/)*[a-zA-Z-_]+\\.(?:[a-z]{1,4})',
        },
        action = wezterm.action_callback(function(window, pane)
          local url = window:get_selection_escapes_for_pane(pane)
          local is_hyperlink = url:find("]8;;")
          if not is_hyperlink then
            return
          end
          local link_start = url:find("]8;;") + 4
          local uri = url:sub(link_start, url:find("\u{1b}", link_start) - 1)
          require("links").open_file_uri_in_nvim_split(window, pane, uri)
        end)
      }),
    },
    {
      mods = M.mod, key = "q", action = act.EmitEvent("trigger-nvim-with-scrollback"),
    },
		{
			mods = M.mod,
			key = "u",
			action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
		},
		-- Panes
		{ mods = M.mod, key = "m", action = act.TogglePaneZoomState },
		{ mods = M.mod, key = "d", action = act.ShowDebugOverlay },
		M.split_nav("resize", "CTRL", "LeftArrow", "Right"),
		M.split_nav("resize", "CTRL", "RightArrow", "Left"),
		M.split_nav("resize", "CTRL", "UpArrow", "Up"),
		M.split_nav("resize", "CTRL", "DownArrow", "Down"),
		M.split_nav("move", "CTRL", "h", "Left"),
		M.split_nav("move", "CTRL", "j", "Down"),
		M.split_nav("move", "CTRL", "k", "Up"),
		M.split_nav("move", "CTRL", "l", "Right"),
		-- Ctrl sequences
		{ mods = "CTRL", key = "i", action = wezterm.action({ SendString = "\u{001b}[105;5u" }) },
		{ mods = "SHIFT", key = "Enter", action = wezterm.action({ SendString = "\u{001b}[13;2u" }) },
		{ mods = "CTRL", key = "Enter", action = wezterm.action({ SendString = "\u{001b}[13;5u" }) },
	}
end

---@param resize_or_move "resize" | "move"
---@param mods string
---@param key string
---@param dir "Right" | "Left" | "Up" | "Down"
function M.split_nav(resize_or_move, mods, key, dir)
	local event = "SplitNav_" .. resize_or_move .. "_" .. dir
	wezterm.on(event, function(win, pane)
		if M.is_nvim(pane) then
			-- pass the keys through to vim/nvim
			win:perform_action({ SendKey = { key = key, mods = mods } }, pane)
		else
			if resize_or_move == "resize" then
				win:perform_action({ AdjustPaneSize = { dir, 3 } }, pane)
			else
				local panes = pane:tab():panes_with_info()
				local is_zoomed = false
				for _, p in ipairs(panes) do
					if p.is_zoomed then
						is_zoomed = true
					end
				end
				wezterm.log_info("is_zoomed: " .. tostring(is_zoomed))
				if is_zoomed then
					dir = dir == "Up" or dir == "Right" and "Next" or "Prev"
					wezterm.log_info("dir: " .. dir)
				end
				win:perform_action({ ActivatePaneDirection = dir }, pane)
				win:perform_action({ SetPaneZoomState = is_zoomed }, pane)
			end
		end
	end)
	return {
		key = key,
		mods = mods,
		action = wezterm.action.EmitEvent(event),
	}
end

function M.is_nvim(pane)
	local process_name = pane:get_foreground_process_name()
	return pane:get_user_vars().IS_NVIM == "true" or (process_name and process_name:find("n?vim") or false)
end

return M
