--[[
        EndeavourOS Awesome WM configuration template.
        More info       :   https://github.com/awesomeWM

        Created by      :   S4NDM4N

        Personal repo   :   https://github.com/s4ndm4n82/eos-awesome-ce

        Offical repo    :   https://github.com/EndeavourOS-Community-Editions/awesome

        Used tecnologies
        ~~~~~~~~~~~~~~~~
        freedesktop     :   https://github.com/lcpz/awesome-freedesktop

        Copycats themes :   https://github.com/lcpz/awesome-copycats

        Lain            :   https://github.com/lcpz/lain

--]]

-- {{{ Required library.
local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

-- Standard awesome library.
local gears         =   require("gears") --Utilities such as color parsing and objects.
local awful         =   require("awful") --Everything related to window managment.
                        require("awful.autofocus")


-- Theme handling library.
local beautiful     =   require("beautiful")

-- Notfication library.
local naughty       =   require("naughty")
naughty.config.defaults['icon_size'] = 100

-- Menubar
local menubar = require("menubar")

-- Other libraries
local lain          =   require("lain")
local freedesktop   =   require("freedesktop")

-- Enabling hotkey help widget for VIM and other apps
-- when client with a matching name is openend:
local hotkeys_popup =   require("awful.hotkeys_popup").widget
                        require("awful.hotkeys_popup.keys")

local myTable       =   awful.util.table or gears.table -- 4.{0,1} compatibility

local bling = require("bling")

local keys = require("keys")

local helpers = require("helpers")
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config.
if awful.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title  = "Oops, there were errors during startup!",
                     text   = awesome.startup_errors })
end

-- Handle runtime errors after startup.
do
local inError = false
awesome.connect_signal("debug::error", function (error)
    -- To avoide endless error loop.
    if inError then return end
    inError = true

    naughty.notify({ preset = naughty.config.presets.critical,
                     title  = "Oops, an error happened!",
                     text   = tostring(error) })
    inError = false
end)
end
-- }}}

-- {{{ To autostart windowsless processes.
local function runOnce(cmdArr)
    for _, cmd in ipairs(cmdArr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

runOnce({ "unclutter -root" }) -- Entries must be comma-separated.
-- }}}


local themes = {
    --[[
    Add the folder name as shown below one after the other as a new line.
    The position of the name is the number you need to add as the number of your
    chosen  theme.
        "powerarrow-blue", -- 1
        "powerarrow",      -- 2
        "multicolor",      -- 3
    --]]
    "eos-default", --1
    "nord", --2
    "powerarrow-dark", --3
    "holo", --4
    "steamburn", --5
    "vertex", --6
}

-- {{{ Choosing your theme.
local themeChosen = themes[2] -- Number is from the above list. Replace with your selected number.
local pathOfTheme = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), themeChosen)
beautiful.init(pathOfTheme)
-- }}}

-- {{{ Default modkeys
local modkey    = "Mod4" -- It's the Windows logo key on the keyboard.
local altkey    = "Mod1" -- Additional modkey.
local ctrl      = "Control" -- Contro button just in case.
-- }}}

-- {{{ Personal variables
local terminal          = "kitty"
local guiEditor         = "kitty lvim"
local filemanager       = "thunar"

-- {{{ Set the path to awesome config file
local rcPath = string.format(" %s/.config/awesome/rc.lua", os.getenv("HOME"))
-- }}}

-- Edit config file command
local configEditor         = guiEditor .. rcPath
-- }}}

-- {{{ awesome variables
awful.util.terminal     = terminal

-- Tage names
-- Use this for reference : https://fontawesome.com/cheatsheet

-- awful.util.tagnames = {  "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }
--awful.util.tagnames = {  "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒", "➓" }
--awful.util.tagnames = { " DEV ", " WWW ", " SYS ", " DOC ", " VBOX ", " CHAT ", " MUS ", " VID ", " GFX " }
--awful.util.tagnames = { "⠐", "⠡", "⠲", "⠵", "⠻", "⠿" }
--awful.util.tagnames = { "⌘", "♐", "⌥", "ℵ" }
--awful.util.tagnames = { "www", "edit", "gimp", "inkscape", "music" }
-- }}}

-- {{{ Layouts
awful.layout.suit.tile.left.mirror = true
awful.layout.layouts = {
    awful.layout.suit.tile,
    lain.layout.termfair.center,
    lain.layout.termfair,
    lain.layout.centerwork,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    -- awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
    --awful.layout.suit.floating,
    lain.layout.centerwork.horizontal,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair.horizontal,
}

lain.layout.termfair.nmaster = 3
lain.layout.termfair.center.nmaster = 3

awful.util.taglist_buttons = myTable.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = myTable.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end),
    awful.button({ }, 3, function ()
        local instance = nil

        return function ()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({theme = {width = 250}})
            end
        end
    end),
    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

beautiful.init(string.format(gears.filesystem.get_configuration_dir() .. "/themes/%s/theme.lua", themeChosen))
-- }}}

-- {{{ Menu
local awesomeMainMenu = {
    { "Hotkeys", function() return false, hotkeys_popup.show_help end },
    { "Manual", terminal .. " -e 'man awesome'" },
    { "Edit Config", configEditor },
    { "Arandr", "arandr" },
    { "Restart", awesome.restart },
}

-- Buiulding the right click menu.
awful.util.rcMainMenu = freedesktop.menu.build({    
    before = {
        { "Awesome", awesomeMainMenu },
        --{ "Awesome", awesomeMainMenu, beautiful.awesome_icon }
        --{ "Atom", "atom" },
        -- Other traids can be put here.

    },
    after = {
        { "Terminal", terminal },
        { "Log out", function() awesome.quit() end},
        { "Sleep", "systemctl suspend" },
        { "Restart", "systemctl reboot" },
        { "Shutdown", "systemctl poweroff" },
        -- Other triads can be put here.
    }
})

-- Menubar configuration.
menubar.utils.terminal = terminal -- Set the terminal for application that needs it.
-- }}}

-- {{{ Wallpaper
-- Re-sets the wallpaper when a screen's geometry changes (e.g. Different resolution).
screen.connect_signal("property::geometry", function(s)
    --Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen.
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)
-- }}}

-- Create a wibox for each screen and add it.
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will matched to these rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = keys.clientKeys,
                     buttons = keys.clientButtons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    },

    -- Titlebar
    { rule_any = { type = { "dialog", "normal" } },
        properties = { titlebars_enabled = false } },

    -- Set applications to always map on the tag 1 on screen 1.
    -- find class or role via xprop command
    --{ rule = { class = browser },
      --properties = { screen = 1, tag = awful.util.tagnames[1] } },

    -- Set applications to always map on the tag 2 on screen 1 with tag switching.
    -- find class or role via xprop command
    --{ rule = { class = terminal },
      --properties = { screen = 1, tag = awful.util.tagnames[2], switchtotag = true  } },

    -- Set applications to always map on the tag 3 on screen 2 with tag switching.
    -- find class or role via xprop command
    --{ rule = { class = terminal },
      --properties = { screen = 2, tag = awful.util.tagnames[3], switchtotag = true  } },

    -- Set applications to be maximized at startup.
    -- find class or role via xprop command
    -- { rule = { class = guiEditor },
    --     properties = { maximized = true } },

    -- Set applications to be maximized at startup with floating disabled.
    -- find class or role via xprop command
    { rule = { class = filemanager },
        properties = { maximized = true, floating = false } },
    { rule = { class = "code" },
        properties = { maximized = false, floating = false } },
    { rule = { class = "Arandr" },
        properties = { maximized = false, floating = false } },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "yad", -- For yad windows.
          "line.exe",
        },
        class = {
          "Galculator",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "veromix",
          "xtightvncviewer",
          "Yad"},

        name = {
          "Event Tester",  -- xev.
          "dropdown",
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

          -- Floating clients but centered in screen
          { rule_any = {
            class = {
                "Polkit-gnome-authentication-agent-1",
                "Arcolinux-calamares-tool.py"
                     },
                    },
           properties = { floating = true },
               callback = function (c)
                    awful.placement.centered(c,nil)
                end }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

--[[ Titlebar
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)
--]]

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal(
  "focus",
  function(c)
    c.border_color = beautiful.border_focus
    c.opacity = 1.0
  end)
client.connect_signal("unfocus",
  function(c)
    c.border_color = beautiful.border_normal
    c.opacity = 0.9
  end)

awful.screen.focus(screen.primary)

for s in screen do
  if s.geometry.width == 3440 then
    bling.module.wallpaper.setup {
      set_function = bling.module.wallpaper.setters.random,
      wallpaper = "/home/gustav/Pictures/nord/nord-wallpapers",
      change_timer = 601,
      position = "fit",
      background = "#2E3440",
      screen = s
    }
  elseif s.geometry.height == 2560 then
    bling.module.wallpaper.setup {
      set_function = bling.module.wallpaper.setters.random,
      wallpaper = "/home/gustav/Pictures/nord/nord-wallpapers-vertical",
      change_timer = 601,
      position = "fit",
      background = "#2E3440",
      screen = s
    }
  end
end


-- }}}

-- {{{ Autostart applications
local autoRun = true -- Makes the if statment to run if set false it will stop.
local autoRunApps = {
    -- List all the apps you need to run on WM startup.
    "nm-applet",
    "light-locker",
    "numlockx on",
    "$HOME/.screenlayout/monitor.sh", -- Use ArandR to create the monitor.sh file.
    "killall firewall-applet && dex --autostart --environment awesome",
    "sleep 1 && picom -b --config  $HOME/.config/picom/picom.conf",
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
    "sleep 1 && kmonad $HOME/.config/kmonad/keychron_k8.kbd"
}

if autoRun then
    -- For loop runs through the above array and add each app to the command.
    for app = 1, #autoRunApps do
        awful.spawn.with_shell(autoRunApps[app])
    end
end
-- }}}
