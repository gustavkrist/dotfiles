--[[

     EndeavourOS Awesome WM theme
     Created by: S4NDM4N

--]]
--{{{ Required libraries.
local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local math, string, os = math, string, os
local myTable = awful.util.table or gears.table -- 4.{0,1} compatibility
-- }}}

local helpers = require("helpers")
local beautiful = require("beautiful")

-- Helper function that updates a taglist item
local update_taglist = function (item, tag, index)
  if tag.selected then
    item.markup = helpers.colorize_text(beautiful.taglist_text_focused[index], beautiful.taglist_fg_focus)
  elseif tag.urgent then
    item.markup = helpers.colorize_text(beautiful.taglist_text_urgent[index], beautiful.taglist_fg_urgent)
  elseif #tag:clients() > 0 then
    item.markup = helpers.colorize_text(beautiful.taglist_text_occupied[index], beautiful.taglist_fg_occupied)
  else
    item.markup = helpers.colorize_text(beautiful.taglist_text_empty[index], beautiful.taglist_fg_empty)
  end
end

-- {{{ Initiating theme variable.
local theme = {}
-- }}}

-- {{{ Assigning values to theme.
-- Theme config folder
theme.dir   = os.getenv("HOME") .. "/.config/awesome/themes/nord"

-- Theme fonts.
theme.font  = "Noto Sans Regular 10"
-- theme.taglist_font = "Noto Sans Regular 10"

theme.nord0  = "#2E3440"
theme.nord1  = "#3B4252"
theme.nord2  = "#434C5E"
theme.nord3  = "#4C566A"
theme.nord4  = "#D8DEE9"
theme.nord5  = "#E5E9F0"
theme.nord6  = "#ECEFF4"
theme.nord7  = "#8FBCBB"
theme.nord8  = "#88C0D0"
theme.nord9  = "#81A1C1"
theme.nord10 = "#5E81AC"
theme.nord11 = "#BF616A"
theme.nord12 = "#D08770"
theme.nord13 = "#EBCB8B"
theme.nord14 = "#A3BE8C"
theme.nord15 = "#B48EAD"

-- Theme colors.
theme.fg_normal                                 = theme.nord6
theme.fg_focus                                  = theme.nord0
theme.fg_urgent                                 = theme.nord11
theme.bg_normal                                 = theme.nord1
theme.bg_focus                                  = theme.nord9
theme.bg_urgent                                 = theme.nord0
-- theme.taglist_fg_focus                          = theme.nord6
theme.tasklist_bg_focus                         = theme.nord0
theme.tasklist_fg_focus                         = theme.nord12
theme.border_normal                             = theme.nord2
theme.border_focus                              = theme.nord9
theme.border_marked                             = theme.nord10
theme.titlebar_bg_focus                         = theme.nord1
theme.titlebar_bg_normal                        = theme.nord1
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus

-- Menu and border widths.
theme.border_width                              = 2
theme.menu_border_width                         = 0
theme.menu_height                               = 25
theme.menu_width                                = 260

theme.lain_icons         = os.getenv("HOME") ..
                           "/.config/awesome/lain/icons/layout/nord/"
-- Icons for the theme.
theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.awesome_icon                              = theme.dir .. "/icons/awesome.png"
-- theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
-- theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile                               = theme.dir .. "/icons/tile.png"
theme.layout_tileleft                           = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop                            = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv                              = theme.dir .. "/icons/fairv.png"
theme.layout_fairh                              = theme.dir .. "/icons/fairh.png"
theme.layout_spiral                             = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle                            = theme.dir .. "/icons/dwindle.png"
theme.layout_max                                = theme.dir .. "/icons/max.png"
theme.layout_fullscreen                         = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.dir .. "/icons/floating.png"
theme.layout_termfair                           = theme.lain_icons .. "termfair.png"
theme.layout_termfairh                          = theme.lain_icons .. "termfairh.png"
theme.layout_centerfair                         = theme.lain_icons .. "centerfair.png"  -- termfair.center
-- theme.layout_cascade                            = theme.lain_icons .. "cascade.png"
-- theme.layout_cascadetile                        = theme.lain_icons .. "cascadetile.png" -- cascade.tile
theme.layout_centerwork                         = theme.lain_icons .. "centerwork.png"
theme.layout_centerworkh                        = theme.lain_icons .. "centerworkh.png" -- centerwork.horizontal
theme.widget_ac                                 = theme.dir .. "/icons/ac.png"
theme.widget_battery                            = theme.dir .. "/icons/battery.png"
theme.widget_battery_low                        = theme.dir .. "/icons/battery_low.png"
theme.widget_battery_empty                      = theme.dir .. "/icons/battery_empty.png"
theme.widget_mem                                = theme.dir .. "/icons/mem.png"
theme.widget_cpu                                = theme.dir .. "/icons/cpu.png"
theme.widget_temp                               = theme.dir .. "/icons/temp.png"
theme.widget_net                                = theme.dir .. "/icons/net.png"
theme.widget_hdd                                = theme.dir .. "/icons/hdd.png"
theme.widget_music                              = theme.dir .. "/icons/note.png"
theme.widget_music_on                           = theme.dir .. "/icons/note.png"
theme.widget_music_pause                        = theme.dir .. "/icons/pause.png"
theme.widget_music_stop                         = theme.dir .. "/icons/stop.png"
theme.widget_vol                                = theme.dir .. "/icons/vol.png"
theme.widget_vol_low                            = theme.dir .. "/icons/vol_low.png"
theme.widget_vol_no                             = theme.dir .. "/icons/vol_no.png"
theme.widget_vol_mute                           = theme.dir .. "/icons/vol_mute.png"
theme.widget_mail                               = theme.dir .. "/icons/mail.png"
theme.widget_mail_on                            = theme.dir .. "/icons/mail_on.png"
theme.widget_task                               = theme.dir .. "/icons/task.png"
theme.widget_scissors                           = theme.dir .. "/icons/scissors.png"
theme.widget_weather                            = theme.dir .. "/icons/dish.png"

-- Tasklist and gap width.
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = 10

-- Titalebar icons
theme.titlebar_close_button_focus               = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.dir .. "/icons/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active        = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"
-- }}}

-- Taglist

theme.taglist_spacing = dpi(5)

-- Generate taglist squares:
-- local taglist_square_size = dpi(4)
-- theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
--     taglist_square_size, theme.fg_normal
-- )
-- theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
--     taglist_square_size, theme.fg_normal
-- )

-- theme.taglist_text_font = "Fira Code Nerd Font Mono"
-- theme.taglist_text_empty    =  {"","","","","","","","",""}
-- theme.taglist_text_occupied =  {"","","","","","","","",""}
-- theme.taglist_text_focused  = {"","","","","","","","",""}
-- theme.taglist_text_urgent   = {"","","","","","","","",""}

-- theme.taglist_text_empty    = {"", "ﴬ", "", "", "﬏", "", "", "", ""}
-- theme.taglist_text_occupied = {"", "ﴬ", "", "", "﬏", "", "", "", ""}
-- theme.taglist_text_focused  = {"", "ﴬ", "", "", "﬏", "", "", "", ""}
-- theme.taglist_text_urgent   = {"", "ﴬ", "", "", "﬏", "", "", "", ""}

-- theme.taglist_text_empty    = {"", "", "", "", "", "", "", "", ""}
-- theme.taglist_text_occupied = {"", "", "", "", "", "", "", "", ""}
-- theme.taglist_text_focused  = {"", "", "", "", "", "", "", "", ""}
-- theme.taglist_text_urgent   = {"", "", "", "", "", "", "", "", ""}

theme.taglist_font = "Fira Code Nerd Font Mono 14"
theme.taglist_bg_focus = theme.bg_normal
theme.taglist_fg_focus = theme.nord13
theme.taglist_bg_occupied = theme.bg_normal
theme.taglist_fg_occupied = theme.nord14
theme.taglist_bg_empty = theme.bg_normal
theme.taglist_fg_empty = theme.nord9
theme.taglist_bg_urgent = theme.bg_normal
theme.taglist_fg_urgent = theme.nord11

local markup = lain.util.markup
local separators = lain.util.separators


-- Textclock
local clockicon = wibox.widget.imagebox(theme.widget_clock)
local clock = awful.widget.watch(
    "date +'%a %d %b %R'", 60,
    function(widget, stdout)
        widget:set_markup(" " .. markup.font(theme.font, stdout))
    end
)

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { clock },
    notification_preset = {
        font = "Noto Sans Mono Medium 10",
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})



-- Taskwarrior
--[[
local task = wibox.widget.imagebox(theme.widget_task)
lain.widget.contrib.task.attach(task, {
     do not colorize output
    show_cmd = "task | sed -r 's/\\x1B\\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g'"
})
task:buttons(gears.table.join(awful.button({}, 1, lain.widget.contrib.task.prompt)))
--]]

-- Mail IMAP check
local mailicon = wibox.widget.imagebox(theme.widget_mail)
--[[ commented because it needs to be set before use
mailicon:buttons(myTable.join(awful.button({ }, 1, function () awful.spawn(mail) end)))
theme.mail = lain.widget.imap({
    timeout  = 180,
    server   = "server",
    mail     = "mail",
    password = "keyring get mail",
    settings = function()
        if mailcount > 0 then
            widget:set_text(" " .. mailcount .. " ")
            mailicon:set_image(theme.widget_mail_on)
        else
            widget:set_text("")
            mailicon:set_image(theme.widget_mail)
        end
    end
})
--]]

-- ALSA volume
theme.volume = lain.widget.alsabar({
    --togglechannel = "IEC958,3",
    notification_preset = { font = theme.font, fg = theme.fg_normal },
})

-- MPD
local musicplr = "urxvt -title Music -g 130x34-320+16 -e ncmpcpp"
local mpdicon = wibox.widget.imagebox(theme.widget_music)
mpdicon:buttons(myTable.join(
    awful.button({ modkey }, 1, function () awful.spawn.with_shell(musicplr) end),
    --[[awful.button({ }, 1, function ()
        awful.spawn.with_shell("mpc prev")
        theme.mpd.update()
    end),
    --]]
    awful.button({ }, 2, function ()
        awful.spawn.with_shell("mpc toggle")
        theme.mpd.update()
    end),
    awful.button({ modkey }, 3, function () awful.spawn.with_shell("pkill ncmpcpp") end),
    awful.button({ }, 3, function ()
        awful.spawn.with_shell("mpc stop")
        theme.mpd.update()
    end)))
theme.mpd = lain.widget.mpd({
    settings = function()
        if mpd_now.state == "play" then
            artist = " " .. mpd_now.artist .. " "
            title  = mpd_now.title  .. " "
            mpdicon:set_image(theme.widget_music_on)
            widget:set_markup(markup.font(theme.font, markup("#FFFFFF", artist) .. " " .. title))
        elseif mpd_now.state == "pause" then
            widget:set_markup(markup.font(theme.font, " mpd paused "))
            mpdicon:set_image(theme.widget_music_pause)
        else
            widget:set_text("")
            mpdicon:set_image(theme.widget_music)
        end
    end
})

-- MEM
local memicon = wibox.widget.imagebox(theme.widget_mem)
local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. mem_now.used .. "MB "))
    end
})

-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. cpu_now.usage .. "% "))
    end
})

--[[ Coretemp (lm_sensors, per core)
local tempwidget = awful.widget.watch({awful.util.shell, '-c', 'sensors | grep Core'}, 30,
function(widget, stdout)
    local temps = ""
    for line in stdout:gmatch("[^\r\n]+") do
        temps = temps .. line:match("+(%d+).*°C")  .. "° " -- in Celsius
    end
    widget:set_markup(markup.font(theme.font, " " .. temps))
end)
--]]
-- Coretemp (lain, average)
--[[
local temp = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. coretemp_now .. "°C "))
    end
})
--]]
local tempicon = wibox.widget.imagebox(theme.widget_temp)

--[[ Weather
https://openweathermap.org/
Type in the name of your city
Copy/paste the city code in the URL to this file in city_id
--]]
--[[
local weathericon = wibox.widget.imagebox(theme.widget_weather)
theme.weather = lain.widget.weather({
    city_id = 2803138, -- placeholder (Belgium)
    notification_preset = { font = "Mononoki Nerd Font 11", fg = theme.fg_normal },
    weather_na_markup = markup.fontfg(theme.font, "#ffffff", "N/A "),
    settings = function()
        descr = weather_now["weather"][1]["description"]:lower()
        units = math.floor(weather_now["main"]["temp"])
        widget:set_markup(markup.fontfg(theme.font, "#ffffff", descr .. " @ " .. units .. "°C "))
    end
})
--]]

--[[ / fs
local fsicon = wibox.widget.imagebox(theme.widget_hdd)
theme.fs = lain.widget.fs({
    notification_preset = { fg = theme.fg_normal, bg = theme.bg_normal, font = "Noto Sans Mono Medium 10" },
    settings = function()
        local fsp = string.format(" %3.2f %s ", fs_now["/"].free, fs_now["/"].units)
        widget:set_markup(markup.font(theme.font, fsp))
    end
})
--]]

-- Battery
local baticon = wibox.widget.imagebox(theme.widget_battery)
local bat = lain.widget.bat({
    settings = function()
        if bat_now.status and bat_now.status ~= "N/A" then
            if bat_now.ac_status == 1 then
                widget:set_markup(markup.font(theme.font, " AC "))
                baticon:set_image(theme.widget_ac)
                return
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
                baticon:set_image(theme.widget_battery_empty)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
                baticon:set_image(theme.widget_battery_low)
            else
                baticon:set_image(theme.widget_battery)
            end
            widget:set_markup(markup.font(theme.font, " " .. bat_now.perc .. "% "))
        else
            widget:set_markup()
            baticon:set_image(theme.widget_ac)
        end
    end
})

-- ALSA volume
local volicon = wibox.widget.imagebox(theme.widget_vol)
theme.volume = lain.widget.alsa({
    settings = function()
        if theme.volume and volume_now.level then -- Stops passing nil values. If not an errors is given when unlocked.
            if volume_now.status == "off" then
                volicon:set_image(theme.widget_vol_mute)
            elseif tonumber(volume_now.level) == 0 then
                volicon:set_image(theme.widget_vol_no)
            elseif tonumber(volume_now.level) <= 50 then
                volicon:set_image(theme.widget_vol_low)
            else
                volicon:set_image(theme.widget_vol)
            end

            widget:set_markup(markup.font(theme.font, " " .. volume_now.level .. "% "))
        end
    end
})
theme.volume.widget:buttons(awful.util.table.join(
  awful.button({}, 1, function()
    awful.spawn.with_shell("/home/gustav/.config/rofi/bin/applet_volume")
  end)
))

-- Net
local neticon = wibox.widget.imagebox(theme.widget_net)
local net = lain.widget.net({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, "#FEFEFE", " " .. net_now.received .. " ↓↑ " .. net_now.sent .. " "))
    end
})

-- Separators
local arrow = separators.arrow_left

function theme.powerline_rl(cr, width, height)
    local arrow_depth, offset = height/2, 0

    -- Avoid going out of the (potential) clip area
    if arrow_depth < 0 then
        width  =  width + 2*arrow_depth
        offset = -arrow_depth
    end

    cr:move_to(offset + arrow_depth         , 0        )
    cr:line_to(offset + width               , 0        )
    cr:line_to(offset + width - arrow_depth , height/2 )
    cr:line_to(offset + width               , height   )
    cr:line_to(offset + arrow_depth         , height   )
    cr:line_to(offset                       , height/2 )

    cr:close_path()
end

local function pl(widget, bgcolor, padding)
    return wibox.container.background(wibox.container.margin(widget, 16, 16), bgcolor, theme.powerline_rl)
end

function theme.at_screen_connect(s)
    -- Quake application
   -- s.quake = lain.util.quake({ app = awful.util.terminal })
   s.quake = lain.util.quake({ app = "termite", height = 0.50, argname = "--name %s" })



    -- If wallpaper is a function, call it with the screen
    -- local wallpaper = theme.wallpaper

    -- if s.geometry.width > s.geometry.height then
    --     fair_layout = awful.layout.suit.fair
    --     tile_layout = awful.layout.suit.tile
    --     -- wallpaper   = theme.dir .. "/wild.png"
    -- else
    --     fair_layout = awful.layout.suit.fair.horizontal
    --     tile_layout = lain.layout.centerwork.horizontal
    --     -- wallpaper   = theme.dir .. "/nord-arctic-fox-vertical.png"
    -- end

    -- if type(wallpaper) == "function" then
    --     wallpaper = wallpaper(s)
    -- end
    -- gears.wallpaper.maximized(wallpaper, s, true)

    -- All tags open with layout 1
    -- awful.tag.add("1",     {screen = s, layout = tile_layout, selected = true})
    -- awful.tag.add("2", {screen = s, layout = tile_layout})
    -- awful.tag.add("3",  {screen = s, layout = tile_layout})
    -- awful.tag.add("4",     {screen = s, layout = tile_layout})
    -- awful.tag.add("5",     {screen = s, layout = tile_layout})
    -- awful.tag.add("6",   {screen = s, layout = tile_layout})
    -- awful.tag.add("7",         {screen = s, layout = tile_layout})
    -- awful.tag.add("8",         {screen = s, layout = tile_layout})
    -- awful.tag.add("9",         {screen = s, layout = tile_layout})

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(myTable.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    -- s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)
    s.mytaglist = wibox.container.margin(awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        -- widget_template = {
        --   widget = wibox.widget.textbox,
        --   create_callback = function(self, tag, index, _)
        --     self.align = "left"
        --     self.valign = "center"
        --     self.font = beautiful.taglist_text_font

        --     update_taglist(self, tag, index)
        --   end,
        --   update_callback = function(self, tag, index, _)
        --     update_taglist(self, tag, index)
        --   end,
        -- },
        buttons = awful.util.taglist_buttons,
    }, dpi(5), 0, 0, 0)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
      screen = s,
      filter = awful.widget.tasklist.filter.currenttags,
      buttons = awful.util.tasklist_buttons,
      layout   = {
        spacing_widget = {
            {
                forced_width  = 5,
                forced_height = 16,
                thickness     = 1,
                color         = '#777777',
                widget        = wibox.widget.separator
            },
            valign = 'center',
            halign = 'center',
            widget = wibox.container.place,
        },
        spacing = 1,
        layout  = wibox.layout.fixed.horizontal
    },
      widget_template = {
        {
          wibox.widget.base.make_widget(),
          forced_height = 5,
          id            = 'background_role',
          widget        = wibox.container.background,
        },
        {
          {
            {
              id     = 'clienticon',
              widget = awful.widget.clienticon,
            },
            {
              id     = 'clientname',
              widget = wibox.widget.textbox
            },
            layout = wibox.layout.fixed.horizontal
          },
          left = 5,
          bottom = 5,
          top = 2,
          widget  = wibox.container.margin
        },
        nil,
---@diagnostic disable-next-line: unused-local
        create_callback = function(self, c, index, objects)
          self:get_children_by_id('clienticon')[1].client = c
          local parts = helpers.splitstr(c.name, '-')
          self:get_children_by_id('clientname')[1].text = parts[#parts]
        end,
        layout = wibox.layout.align.vertical,
      },
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 20, bg = theme.bg_normal, fg = theme.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            --spr,
            s.mytaglist,
            s.mypromptbox,
            spr,
        },
        nil,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            --[[ using shapes
            pl(wibox.widget { mpdicon, theme.mpd.widget, layout = wibox.layout.align.horizontal }, "#343434"),
            pl(task, "#343434"),
            --pl(wibox.widget { mailicon, mail and mail.widget, layout = wibox.layout.align.horizontal }, "#343434"),
            pl(wibox.widget { memicon, mem.widget, layout = wibox.layout.align.horizontal }, "#777E76"),
            pl(wibox.widget { cpuicon, cpu.widget, layout = wibox.layout.align.horizontal }, "#4B696D"),
            pl(wibox.widget { tempicon, temp.widget, layout = wibox.layout.align.horizontal }, "#4B3B51"),
            pl(wibox.widget { fsicon, theme.fs.widget, layout = wibox.layout.align.horizontal }, "#CB755B"),
            pl(wibox.widget { baticon, bat.widget, layout = wibox.layout.align.horizontal }, "#8DAA9A"),
            pl(wibox.widget { neticon, net.widget, layout = wibox.layout.align.horizontal }, "#C0C0A2"),
            pl(binclock.widget, "#777E76"),
            --]]
            -- using separators
            --arrow(theme.bg_normal, "#343434"),
           -- wibox.container.background(wibox.container.margin(wibox.widget { mailicon, mail and mail.widget, layout = wibox.layout.align.horizontal }, 4, 7), "#343434"),
            --arrow("alpha", theme.nord9),
            --wibox.container.background(wibox.container.margin(wibox.widget { mpdicon, theme.mpd.widget, layout = wibox.layout.align.horizontal }, 3, 6), theme.nord9),
            arrow("alpha", theme.nord9),
            wibox.container.background(wibox.container.margin(wibox.widget { memicon, mem.widget, layout = wibox.layout.align.horizontal }, 2, 3), theme.nord9),
            arrow(theme.nord9, theme.nord10),
            wibox.container.background(wibox.container.margin(wibox.widget { cpuicon, cpu.widget, layout = wibox.layout.align.horizontal }, 3, 4), theme.nord10),
            --arrow(theme.nord10, theme.nord9),
            --wibox.container.background(wibox.container.margin(wibox.widget { tempicon, temp.widget, layout = wibox.layout.align.horizontal }, 4, 4), theme.nord9),
            --arrow(theme.nord9, theme.nord10),
            --wibox.container.background(wibox.container.margin(wibox.widget { weathericon, theme.weather.widget, layout = wibox.layout.align.horizontal }, 3, 3), theme.nord10),
            arrow(theme.nord10, theme.nord9),
            wibox.container.background(wibox.container.margin(wibox.widget { baticon, bat.widget, layout = wibox.layout.align.horizontal }, 3, 3), theme.nord9),
            arrow(theme.nord9, theme.nord10),
            wibox.container.background(wibox.container.margin(wibox.widget { volicon, theme.volume.widget, layout = wibox.layout.align.horizontal }, 2, 3), theme.nord10),
            arrow(theme.nord10, theme.nord9),
            wibox.container.background(wibox.container.margin(wibox.widget { nil, neticon, net.widget, layout = wibox.layout.align.horizontal }, 3, 3), theme.nord9),            
            arrow(theme.nord9, theme.nord10),
            wibox.container.background(wibox.container.margin(clock, 4, 8), theme.nord10),
            arrow(theme.nord10, "alpha"),
            wibox.widget.systray(),
            --s.mylayoutbox,
        },
    }

    -- Creating the bottom wibox.
    s.mybottomwibox = awful.wibar({ position = "bottom", screen = s, border_width = 0, height = 30, bg = theme.bg_normal, fg = theme.fg_normal })

    -- Adding widgets to the bottom wibox.
    s.mybottomwibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
        },
        {
          layout = wibox.container.place,
          halign = 'center',
          valign = 'center',
          s.mytasklist,
        },
        -- s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            s.mylayoutbox,
        },
    }

end

return theme
