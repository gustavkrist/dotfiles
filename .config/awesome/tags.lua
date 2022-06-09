local awful      = require("awful")
local lain       = require("lain")
local sharedtags = require("sharedtags")
local gears      = require("gears")
local myTable    = awful.util.table or gears.table -- 4.{0,1} compatibility

-- {{{ Default modkeys
local modkey     = "Mod4" -- It's the Windows logo key on the keyboard.
local altkey     = "Mod1" -- Additional modkey.
local ctrl       = "Control" -- Contro button just in case.
-- }}}

local tags = sharedtags {
    { name = "", screen = 1, layout = awful.layout.suit.tile },
    { name = "", screen = 1, layout = awful.layout.suit.tile },
    { name = "﬏", screen = 1, layout = awful.layout.suit.tile },
    { name = "ﴬ", screen = 2, layout = awful.layout.suit.tile },
    { name = "", screen = 2, layout = awful.layout.suit.tile },
    { name = "", screen = 2, layout = awful.layout.suit.tile },
    { name = "", screen = 3, layout = lain.layout.centerwork.horizontal },
    { name = "", screen = 3, layout = lain.layout.centerwork.horizontal },
    { name = "", screen = 3, layout = lain.layout.centerwork.horizontal }
}


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

return tags
