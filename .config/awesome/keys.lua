local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

local gears         =   require("gears") --Utilities such as color parsing and objects.
local awful         =   require("awful") --Everything related to window managment.
local naughty       =   require("naughty")

-- Theme handling library.
local beautiful     =   require("beautiful")
local dpi           =   beautiful.xresources.apply_dpi

-- Other libraries
local lain          =   require("lain")

local hotkeys_popup =   require("awful.hotkeys_popup").widget
                        require("awful.hotkeys_popup.keys")

-- Menubar
local menubar       = require("menubar")

local bling         = require("bling")

local myTable       =   awful.util.table or gears.table -- 4.{0,1} compatibility

-- {{{ Default modkeys
local modkey    = "Mod4" -- It's the Windows logo key on the keyboard.
local altkey    = "Mod1" -- Additional modkey.
local ctrl      = "Control" -- Contro button just in case.
-- }}}

-- {{{ Personal variables
local browser           = "google-chrome-stable"
local terminal          = "kitty"
local editor            = os.getenv("EDITOR") or "nano"
local guiEditor         = "neovide"
local filemanager       = "thunar"
local lockscreen        = "light-locker-command -l"

-- {{{ Mosue bindings.
root.buttons(myTable.join(
    awful.button({ }, 3, function () awful.util.rcMainMenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- ===================================================================
-- Movement Functions (Called by some keybinds)
-- ===================================================================


-- Move given client to given direction
local function move_client(c, direction)
   -- If client is floating, move to edge
   if c.floating or (awful.layout.get(mouse.screen) == awful.layout.suit.floating) then
      local workarea = awful.screen.focused().workarea
      if direction == "up" then
         c:geometry({nil, y = workarea.y + beautiful.useless_gap * 2, nil, nil})
      elseif direction == "down" then
         c:geometry({nil, y = workarea.height + workarea.y - c:geometry().height - beautiful.useless_gap * 2 - beautiful.border_width * 2, nil, nil})
      elseif direction == "left" then
         c:geometry({x = workarea.x + beautiful.useless_gap * 2, nil, nil, nil})
      elseif direction == "right" then
         c:geometry({x = workarea.width + workarea.x - c:geometry().width - beautiful.useless_gap * 2 - beautiful.border_width * 2, nil, nil, nil})
      end
   -- Otherwise swap the client in the tiled layout
   elseif awful.layout.get(mouse.screen) == awful.layout.suit.max then
      if direction == "up" or direction == "left" then
         awful.client.swap.byidx(-1, c)
      elseif direction == "down" or direction == "right" then
         awful.client.swap.byidx(1, c)
      end
   else
      awful.client.swap.bydirection(direction, c, nil)
   end
end


-- Resize client in given direction
local floating_resize_amount = dpi(20)
local tiling_resize_factor = 0.05

local function resize_client(c, direction)
   if awful.layout.get(mouse.screen) == awful.layout.suit.floating or (c and c.floating) then
      if direction == "up" then
         c:relative_move(0, 0, 0, -floating_resize_amount)
      elseif direction == "down" then
         c:relative_move(0, 0, 0, floating_resize_amount)
      elseif direction == "left" then
         c:relative_move(0, 0, -floating_resize_amount, 0)
      elseif direction == "right" then
         c:relative_move(0, 0, floating_resize_amount, 0)
      end
   else
      if direction == "up" then
         awful.client.incwfact(-tiling_resize_factor)
      elseif direction == "down" then
         awful.client.incwfact(tiling_resize_factor)
      elseif direction == "left" then
         awful.tag.incmwfact(-tiling_resize_factor)
      elseif direction == "right" then
         awful.tag.incmwfact(tiling_resize_factor)
      end
   end
end


-- raise focused client
local function raise_client()
   if client.focus then
      client.focus:raise()
   end
end




-- {{{ Key bindings
local globalKeys = myTable.join(
    -- {{{ Personal keybindings.
    -- Awesome menubar
    awful.key({ modkey }, "d", function () awful.spawn.with_shell(
        os.getenv("HOME") .. "/.config/rofi/bin/launcher_text"
        ) end,
        {description = "Show awesome menubar.", group = "Hotkeys"}),
    awful.key({ modkey }, "w", function () awful.spawn.with_shell(
        os.getenv("HOME") .. "/.config/rofi/bin/launcher_window_text"
        ) end,
        {description = "Show the main menu.", group = "Hotkeys"}),

    -- Awesome
    awful.key({ modkey }, "F1", hotkeys_popup.show_help,
        {description = "Launches this help.", group="Awesome"}),
    awful.key({ modkey }, "r", awesome.restart,
        {description = "Reloads awesome.", group="Awesome"}),
    awful.key({ modkey }, "Escape", function () awful.spawn.with_shell( "killall awesome" ) end,
        {description = "Quit awesome.", group="Awesome"}),

    -- Show/Hide top wibox
    awful.key({ modkey, "Shift" }, "b", function ()
        for s in screen do
            s.mywibox.visible = not s.mywibox.visible
            if s.mybottomwibox then
                s.mybottomwibox.visible = not s.mybottomwibox.visible
            end
        end
    end,
    {description = "Toggle top wibox.", group = "Awesome"}),


    -- Launching applications
    awful.key({ modkey }, "F2", function () awful.util.spawn( guiEditor ) end,
        {description = "Launch the text editor." , group = "Function keys" }),
    awful.key({ modkey }, "F3", function () awful.util.spawn( filemanager ) end,
        {description = "Launch the filemanager", group = "Function keys" }),
    awful.key({ modkey }, "F4", function () awful.util.spawn( "tdrop -ma -w 70% -x 15% -y 20 -s dropdown kitty" ) end,
        {description = "Dropdown terminal.", group = "Function keys"}),
    awful.key({ modkey }, "Return", function () awful.util.spawn( terminal ) end,
        {description = "Launch the terminal.", group="Hotkeys"}),
    awful.key({ modkey, "Shift" }, "Return", function () awful.util.spawn( filemanager ) end,
        {description = "Launches the filemanager.", group = "Hotkeys" }),
    awful.key({ modkey }, "b", function () awful.util.spawn( browser ) end,
        {description = "Launch default browser.", group = "Hotkeys" }),
    awful.key({ modkey }, "e", function () awful.util.spawn( guiEditor ) end,
        {description = "Launch graphical text editor.", group = "Hotkeys" }),
    awful.key({ modkey }, "t", function () awful.util.spawn( editor ) end,
        {description = "Launch default terminal editor.", group = "Hotkeys" }),
    awful.key({ modkey, ctrl, altkey }, "l", function () awful.util.spawn( lockscreen ) end,
        {description = "Locks the screen on demand.", group = "Hotkeys" }),
    awful.key({ modkey }, "c", function () awful.util.spawn( "code" ) end,
        {description = "Launches Visual Studio Code.", group = "Hotkeys" }),

    -- Copy primary to clipboard (terminals to gtk)
    awful.key({ modkey, ctrl }, "c", function () awful.spawn.with_shell("xsel | xsel -i -b") end,
        {description = "Copy terminal to gtk.", group = "Hotkeys"}),
    -- Copy clipboard to primary (gtk to terminals)
    awful.key({ modkey, ctrl }, "v", function () awful.spawn.with_shell("xsel -b | xsel") end,
        {description = "Copy gtk to terminal.", group = "Hotkeys"}),

    -- Super + ... eos apps.
    awful.key({ modkey, "Shift" }, "w", function () awful.util.spawn( "eos-welcome --enable" ) end,
        {description = "EndeavourOS welcome app.", group = "EOS Apps" }),
    awful.key({ ctrl, altkey }, "l", function () awful.util.spawn( "eos-log-tool" ) end,
        {description = "EndeavourOS log tool.", group = "EOS Apps" }),
    awful.key({ modkey, "Shift" }, "i", function () awful.util.spawn( "eos-apps-info" ) end,
        {description = "EndeavourOS log tool.", group = "EOS Apps" }),
    awful.key({ modkey, "Shift" }, "r", function () awful.util.spawn( "reflector-simple" ) end,
        {description = "EndeavourOS reflector simple.", group = "EOS Apps" }),
    awful.key({ modkey, "Shift" }, "m", function () awful.util.spawn( terminal .. "-e eos-rankmirrors" ) end,
        {description = "EndeavourOS rank mirrors.", group = "EOS Apps" }),

    -- Screenshots
    awful.key({ }, "Print", function () awful.util.spawn( "xfce4-screenshooter -i" ) end,
        {description = "Use xfce screenshooter.", group = "Screenshots" }),

    awful.key({ altkey }, "Escape", awful.tag.history.restore,
        {description = "Go back.", group = "Tag"}),

     -- Tag browsing alt + tab
    awful.key({ altkey }, "Tab",   awful.tag.viewnext,
        {description = "View next.", group = "Tag"}),
    awful.key({ altkey, "Shift" }, "Tab",  awful.tag.viewprev,
        {description = "View previous.", group = "Tag"}),

   -- =========================================
   -- FUNCTION KEYS
   -- =========================================

   -- -- Brightness
   -- awful.key({}, "XF86MonBrightnessUp",
   --    function()
   --       awful.spawn("~/.local/bin/brightness + 5", false)
   --    end,
   --    {description = "+5%", group = "Hotkeys"}
   -- ),
   -- awful.key({}, "XF86MonBrightnessDown",
   --    function()
   --       awful.spawn("~/.local/bin/brightness - 5", false)
   --    end,
   --    {description = "-5%", group = "Hotkeys"}
   -- ),

   -- ALSA volume control
   awful.key({}, "XF86AudioRaiseVolume",
      function()
         awful.spawn("amixer -D pulse set Master 5%+", false)
         awesome.emit_signal("volume_change")
      end,
      {description = "volume up", group = "Hotkeys"}
   ),
   awful.key({}, "XF86AudioLowerVolume",
      function()
         awful.spawn("amixer -D pulse set Master 5%-", false)
         awesome.emit_signal("volume_change")
      end,
      {description = "volume down", group = "Hotkeys"}
   ),
   awful.key({}, "XF86AudioMute",
      function()
         awful.spawn("amixer -D pulse set Master 1+ toggle", false)
         awesome.emit_signal("volume_change")
      end,
      {description = "toggle mute", group = "Hotkeys"}
   ),
   awful.key({}, "XF86AudioNext",
      function()
         awful.spawn("mpc next", false)
      end,
      {description = "next music", group = "Hotkeys"}
   ),
   awful.key({}, "XF86AudioPrev",
      function()
         awful.spawn("mpc prev", false)
      end,
      {description = "previous music", group = "Hotkeys"}
   ),
   awful.key({}, "XF86AudioPlay",
      function()
         awful.spawn("echo test > /home/gustav/test.txt", false)
      end,
      {description = "play/pause music", group = "Hotkeys"}
   ),

   -- =========================================
   -- CLIENT FOCUSING
   -- =========================================

   -- Focus client by direction (hjkl keys)
   awful.key({modkey}, "j",
      function()
         awful.client.focus.bydirection("down")
         bling.module.flash_focus.flashfocus(client.focus)
      end,
      {description = "focus down", group = "Client"}
   ),
   awful.key({modkey}, "k",
      function()
         awful.client.focus.bydirection("up")
         bling.module.flash_focus.flashfocus(client.focus)
      end,
      {description = "focus up", group = "Client"}
   ),
   awful.key({modkey}, "h",
      function()
         awful.client.focus.bydirection("left")
         bling.module.flash_focus.flashfocus(client.focus)
      end,
      {description = "focus left", group = "Client"}
   ),
   awful.key({modkey}, "l",
      function()
         awful.client.focus.bydirection("right")
         bling.module.flash_focus.flashfocus(client.focus)
      end,
      {description = "focus right", group = "Client"}
   ),

   -- Focus client by direction (arrow keys)
   awful.key({modkey}, "Down",
      function()
         awful.client.focus.bydirection("down")
         bling.module.flash_focus.flashfocus(client.focus)
      end,
      {description = "focus down", group = "Client"}
   ),
   awful.key({modkey}, "Up",
      function()
         awful.client.focus.bydirection("up")
         bling.module.flash_focus.flashfocus(client.focus)
      end,
      {description = "focus up", group = "Client"}
   ),
   awful.key({modkey}, "Left",
      function()
         awful.client.focus.bydirection("left")
         bling.module.flash_focus.flashfocus(client.focus)
      end,
      {description = "focus left", group = "Client"}
   ),
   awful.key({modkey}, "Right",
      function()
         awful.client.focus.bydirection("right")
         bling.module.flash_focus.flashfocus(client.focus)
      end,
      {description = "focus right", group = "Client"}
   ),

   -- Focus client by index (cycle through clients)
   awful.key({modkey}, "Tab",
      function()
         awful.client.focus.byidx(1)
         bling.module.flash_focus.flashfocus(client.focus)
      end,
      {description = "focus next by index", group = "Client"}
   ),
   awful.key({modkey, "Shift"}, "Tab",
      function()
         awful.client.focus.byidx(-1)
         bling.module.flash_focus.flashfocus(client.focus)
      end,
      {description = "focus previous by index", group = "Client"}
   ),

   -- =========================================
   -- CLIENT RESIZING
   -- =========================================

   awful.key({modkey, "Control"}, "Down",
      function(c)
         resize_client(client.focus, "down")
      end
   ),
   awful.key({modkey, "Control"}, "Up",
      function(c)
         resize_client(client.focus, "up")
      end
   ),
   awful.key({modkey, "Control"}, "Left",
      function(c)
         resize_client(client.focus, "left")
      end
   ),
   awful.key({modkey, "Control"}, "Right",
      function(c)
         resize_client(client.focus, "right")
      end
   ),
   awful.key({modkey, "Control"}, "j",
      function(c)
         resize_client(client.focus, "down")
      end
   ),
   awful.key({ modkey, "Control" }, "k",
      function(c)
         resize_client(client.focus, "up")
      end
   ),
   awful.key({modkey, "Control"}, "h",
      function(c)
         resize_client(client.focus, "left")
      end
   ),
   awful.key({modkey, "Control"}, "l",
      function(c)
         resize_client(client.focus, "right")
      end
   ),

   -- =========================================
   -- NUMBER OF MASTER / COLUMN CLIENTS
   -- =========================================

   -- Number of master clients
   awful.key({modkey, altkey}, "h",
      function()
         awful.tag.incnmaster( 1, nil, true)
      end,
      {description = "increase the number of master clients", group = "Layout"}
   ),
   awful.key({ modkey, altkey }, "l",
      function()
         awful.tag.incnmaster(-1, nil, true)
      end,
      {description = "decrease the number of master clients", group = "Layout"}
   ),
   awful.key({ modkey, altkey }, "Left",
      function()
         awful.tag.incnmaster( 1, nil, true)
      end,
      {description = "increase the number of master clients", group = "Layout"}
   ),
   awful.key({ modkey, altkey }, "Right",
      function()
         awful.tag.incnmaster(-1, nil, true)
      end,
      {description = "decrease the number of master clients", group = "Layout"}
   ),

   -- Number of columns
   awful.key({modkey, altkey}, "k",
      function()
         awful.tag.incncol(1, nil, true)
      end,
      {description = "increase the number of columns", group = "Layout"}
   ),
   awful.key({modkey, altkey}, "j",
      function()
         awful.tag.incncol(-1, nil, true)
      end,
      {description = "decrease the number of columns", group = "Layout"}
   ),
   awful.key({modkey, altkey}, "Up",
      function()
         awful.tag.incncol(1, nil, true)
      end,
      {description = "increase the number of columns", group = "Layout"}
   ),
   awful.key({modkey, altkey}, "Down",
      function()
         awful.tag.incncol(-1, nil, true)
      end,
      {description = "decrease the number of columns", group = "Layout"}
   ),

   -- =========================================
   -- GAP CONTROL
   -- =========================================

   -- Gap control
   awful.key({modkey, "Shift"}, "minus",
      function()
         awful.tag.incgap(5, nil)
      end,
      {description = "increment gaps size for the current tag", group = "gaps"}
   ),
   awful.key({modkey}, "minus",
      function()
         awful.tag.incgap(-5, nil)
      end,
      {description = "decrement gap size for the current tag", group = "gaps"}
   ),

   -- =========================================
   -- LAYOUT SELECTION
   -- =========================================

   -- select next layout
   awful.key({modkey}, "space",
      function()
         awful.layout.inc(1)
      end,
      {description = "select next", group = "Layout"}
   ),
   -- select previous layout
   awful.key({modkey, "Shift"}, "space",
      function()
         awful.layout.inc(-1)
      end,
      {description = "select previous", group = "Layout"}
   ),

    -- Layout manipulation
    awful.key({ modkey, ctrl }, "s", function () awful.screen.focus_relative( 1) end,
        {description = "Focus the next screen.", group = "Screen"}),
    awful.key({ modkey, ctrl }, "a", function () awful.screen.focus_relative(-1) end,
        {description = "Focus the previous screen.", group = "Screen"}),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto,
        {description = "Jump to urgent client", group = "Client"}),
    awful.key({ ctrl }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "Go back.", group = "Client"}),

    -- Dynamic tagging
    awful.key({ modkey, "Shift" }, "n", function () lain.util.add_tag() end,
              {description = "Add new tag.", group = "Tag"}),
    awful.key({ modkey, ctrl }, "r", function () lain.util.rename_Tag() end,
              {description = "Rename tag.", group = "Tag"}),
    awful.key({ modkey, "Shift" }, "Left", function () lain.util.move_tag(-1) end,
              {description = "Move tag to the left.", group = "Tag"}),
    awful.key({ modkey, "Shift" }, "Right", function () lain.util.move_tag(1) end,
              {description = "Move tag to the right", group = "Tag"}),
    awful.key({ modkey, "Shift" }, "y", function () lain.util.delete_tag() end,
              {description = "Delete tag", group = "Tag"}),

    -- Retore window
    awful.key({ modkey, ctrl }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "Restore minimized.", group = "Client"}),

    -- ALSA volume control
    awful.key({ modkey, "Shift"}, "Up",
        function ()
            os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel))
            beautiful.volume.update() end,
            {description = "Volumn up.", group = "Audio"}),
    awful.key({ modkey, "Shift" }, "Down",
        function ()
            os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel))
            beautiful.volume.update() end,
            {description = "Volumn down.", group = "Audio"}),
    awful.key({ }, "XF86MonBrightnessDown",
        function ()
            os.execute("/home/gustav/.local/bin/brightness - 5")
        end,
        {description = "Brightness down", group = "Hotkeys"}),
    awful.key({ }, "XF86MonBrightnessUp",
        function ()
            os.execute("/home/gustav/.local/bin/brightness + 5")
        end,
        {description = "Brightness up", group = "Hotkeys"}),
    awful.key({ modkey, ctrl }, "equal",
        function ()
            os.execute("/home/gustav/.local/bin/brightness toggle")
        end,
        {description = "Brightness toggle", group = "Hotkeys"}),
    awful.key({ modkey, altkey }, "m",
        function ()
            os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
            beautiful.volume.update() end,
            {description = "Volumn mute.", group = "Audio"}),
    awful.key({ modkey, "Shift" }, "m",
        function ()
            os.execute(string.format("amixer -q set %s 100%%", beautiful.volume.channel))
            beautiful.volume.update() end,
            {description = "Volumn full.", group = "Audio"}),
    awful.key({ modkey, "Shift" }, "0",
        function ()
            os.execute(string.format("amixer -q set %s 0%%", beautiful.volume.channel))
            beautiful.volume.update() end,
            {description = "Volumn 0.", group = "Audio"})

    -- }}}
)

local clientKeys = myTable.join(
   -- Move to edge or swap by direction
   awful.key({modkey, "Shift"}, "Down",
      function(c)
         move_client(c, "down")
      end
   ),
   awful.key({modkey, "Shift"}, "Up",
      function(c)
         move_client(c, "up")
      end
   ),
   awful.key({modkey, "Shift"}, "Left",
      function(c)
         move_client(c, "left")
      end
   ),
   awful.key({modkey, "Shift"}, "Right",
      function(c)
         move_client(c, "right")
      end
   ),
   awful.key({modkey, "Shift"}, "j",
      function(c)
         move_client(c, "down")
      end
   ),
   awful.key({modkey, "Shift"}, "k",
      function(c)
         move_client(c, "up")
      end
   ),
   awful.key({modkey, "Shift"}, "h",
      function(c)
         move_client(c, "left")
      end
   ),
   awful.key({modkey, "Shift"}, "l",
      function(c)
         move_client(c, "right")
      end
   ),
    awful.key({ altkey, "Shift" }, "m", lain.util.magnify_client,
              {description = "Magnify client", group = "Client"}),
    awful.key({ modkey }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "Toggle fullscreen", group = "Client"}),
    awful.key({ modkey }, "q", function (c) c:kill() end,
              {description = "Close", group = "Hotkeys"}),
    awful.key({ modkey, "Shift" }, "f",  awful.client.floating.toggle,
              {description = "Toggle floating", group = "Client"}),
    awful.key({ modkey, ctrl }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "Move to master", group = "Client"}),
    awful.key({ modkey }, "o", function (c) c:move_to_screen() end,
              {description = "Move to screen", group = "Client"}),
    awful.key({ modkey }, "t", function (c) c.ontop = not c.ontop end,
              {description = "Toggle keep on top", group = "Client"}),
    awful.key({ modkey }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "Minimize", group = "Client"}),
    awful.key({ modkey }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "Maximize", group = "Client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = "View tag #", group = "Tag"}
        descr_toggle = {description = "Toggle tag #", group = "Tag"}
        descr_move = {description = "Move focused client to tag #", group = "Tag"}
        descr_toggle_focus = {description = "Toggle focused client on tag #", group = "Tag"}
    end
    globalKeys = myTable.join(globalKeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  descr_view),
        -- Toggle tag display.
        awful.key({ modkey, ctrl }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  descr_toggle),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  descr_move),
        -- Toggle tag on focused client.
        awful.key({ modkey, ctrl, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  descr_toggle_focus)
    )
end

local clientButtons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)
-- }}}

-- {{{ Set keys
root.keys(globalKeys)
-- }}}

return {clientKeys = clientKeys, clientButtons = clientButtons}
