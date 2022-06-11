    -- Base
import XMonad
import System.Directory
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

    -- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.GridSelect
import XMonad.Actions.GroupNavigation
import XMonad.Actions.MouseResize
import XMonad.Actions.Navigation2D
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.Search as S

    -- Data
import Data.Char (isSpace, toUpper)
import Data.Maybe (fromJust)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
import qualified Data.Map as M

    -- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)
import XMonad.Hooks.DynamicProperty
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.WorkspaceHistory

    -- Layouts
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

    -- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
-- import XMonad.Layout.WindowNavigation
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

   -- Utilities
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce

   -- ColorScheme module (SET ONLY ONE!)
      -- Possible choice are:
      -- DoomOne
      -- Dracula
      -- GruvboxDark
      -- MonokaiPro
      -- Nord
      -- OceanicNext
      -- Palenight
      -- SolarizedDark
      -- SolarizedLight
      -- TomorrowNight
import Colors.Nord

myFont :: String
myFont = "xft:Fira Code Nerd Font Mono:regular:size=9:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask        -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "kitty"    -- Sets default terminal

myBrowser :: String
myBrowser = "google-chrome-stable "  -- Sets qutebrowser as browser

myEditor :: String
myEditor = "neovide "  -- Set neovide as editor
-- myEditor = myTerminal ++ " -e vim "    -- Sets vim as editor

myBorderWidth :: Dimension
myBorderWidth = 2           -- Sets border width for windows

myNormColor :: String       -- Border color of normal windows
myNormColor   = color09     -- This variable is imported from Colors.THEME

myFocusColor :: String      -- Border color of focused windows
myFocusColor  = color15     -- This variable is imported from Colors.THEME

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myStartupHook :: X ()
myStartupHook = do
    spawn "killall conky"   -- kill current conky on each restart
    spawn "killall trayer"  -- kill current trayer on each restart
    spawn "killall kmonad"  -- kill current kmonad on each restart

    spawnOnce "light-locker"
    spawnOnce "nm-applet"
    spawnOnce "numlockx on"
    spawnOnce "$HOME/.screenlayout/monitor.sh"
    spawnOnce "sleep 1 && picom -b --config  $HOME/.config/picom/picom.conf"
    spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"

    spawn "sleep 2 && kmonad $HOME/.config/kmonad/keychron_k8.kbd"
    spawn ("sleep 2 && conky -c $HOME/.config/conky/xmonad/" ++ colorScheme ++ "-01.conkyrc")
    spawn ("sleep 2 && trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 " ++ colorTrayer ++ " --height 30")

    -- spawnOnce "xargs xwallpaper --stretch < ~/.cache/wall"
    -- spawnOnce "~/.fehbg &"  -- set last saved feh wallpaper
    spawnOnce "feh --bg-scale $(shuf -n 1 -e ~/Pictures/nord/nord-wallpapers/*) --bg-scale $(shuf -n 1 -e ~/Pictures/nord/nord-wallpapers/*) --bg-scale $(shuf -n 1 -e ~/Pictures/nord/nord-wallpapers-vertical/*)"  -- feh set random wallpaper
    -- spawnOnce "nitrogen --restore &"   -- if you prefer nitrogen to feh
    spawnOnce "xsetroot -cursor_name left_ptr"
    setWMName "LG3D"

myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x4C,0x56,0x6A) -- lowest inactive bg
                  (0x4C,0x56,0x6A) -- highest inactive bg
                  (0x5E,0x81,0xAC) -- active bg
                  (0xD8,0xDE,0xE9) -- inactive fg
                  (0xD8,0xDE,0xE9) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm   findTerm   manageTerm
                , NS "python"   spawnPython findPython managePython
                ]
  where
    spawnTerm    = myTerminal ++ " --title=scratchpad"
    findTerm     = title =? "scratchpad"
    manageTerm   = customFloating $ W.RationalRect l t w h
                 where
                   h = 0.9
                   w = 0.9
                   t = 0.95 -h
                   l = 0.95 -w
    spawnPython  = myTerminal ++ " --title=python zsh -c \"PATH=/home/gustav/.local/bin:$PATH EDITOR=lvim ipython\""
    findPython   = title =? "python"
    managePython = customFloating $ W.RationalRect l t w h
                 where
                   h = 0.9
                   w = 0.9
                   t = 0.95 -h
                   l = 0.95 -w

--Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
-- limitWindows n sets maximum number of windows displayed for layout.
-- mySpacing n sets the gap size around the windows.
tall     = renamed [Replace "tall"]
           $ smartBorders
           -- $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
threeCol = renamed [Replace "threeCol"]
           $ smartBorders
           -- $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ mySpacing 8
           $ ThreeColMid 1 (3/100) (2/5)
threeRow = renamed [Replace "threeRow"]
           $ smartBorders
           -- $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ mySpacing 8
           -- Mirror takes a layout and rotates it by 90 degrees.
           -- So we are applying Mirror to the ThreeCol layout.
           $ Mirror
           $ ThreeColMid 1 (3/100) (2/5)
monocle  = renamed [Replace "monocle"]
           $ smartBorders
           -- $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 20 Full
floats   = renamed [Replace "floats"]
           $ smartBorders
           $ limitWindows 20 simplestFloat
grid     = renamed [Replace "grid"]
           $ smartBorders
           -- $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 8
           $ mkToggle (single MIRROR)
           $ Grid (16/10)

-- setting colors for tabs layout and tabs sublayout.
myTabTheme = def { fontName            = myFont
                 , activeColor         = color15
                 , inactiveColor       = color09
                 , activeBorderColor   = color15
                 , inactiveBorderColor = color09
                 , activeTextColor     = colorBack
                 , inactiveTextColor   = color16
                 }

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:JetbrainsMono Nerd Font:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = color09
    , swn_color             = colorFore
    }

-- The layout hook
myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) $
               onWorkspaces [(myWorkspaces !! (i-1)) | i <- [3,7,8]] (
                    withBorder myBorderWidth threeRow
                ||| noBorders monocle
                ||| grid
                ||| floats) $ myDefaultLayout
             where
               myDefaultLayout =     withBorder myBorderWidth tall
                                 ||| threeCol
                                 ||| noBorders monocle
                                 ||| grid
                                 ||| floats
                                 ||| threeRow

-- myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
-- myWorkspaces = ["  ", "  ", "  ", " ﴬ ", "  ", "  ", " ﬏ ", "  ", "  "]
myWorkspaces = [" \xf8dd ", " \xf489 ", " \xf8de ", " \xfd2c ", " \xfb0f ", " \xf268 ", " \xf085 ", " \xf885 ", " \xf10c "]
-- myWorkspaces = [" dev ", " www ", " sys ", " doc ", " vbox ", " chat ", " mus ", " vid ", " gfx "]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = 
    let
     myClassFloats = [ "Yad"
                     , "confirm"
                     , "file_progress"
                     , "dialog"
                     , "download"
                     , "error"
                     , "notification"]
     myTitleFloats = ["Event Tester", "dropdown"]
     myNotes       = ["inkdrop"]
     myClassMoves  = [ ("inkdrop", 4) 
                     , ("Code",    5)]
    in 
     (composeAll . concat $
    [
      [ className =? c      --> doFloat | c <- myClassFloats ]
    , [ title     =? t      --> doFloat | t <- myTitleFloats ]
    , [ className =? c      --> doF ( W.shift ( myWorkspaces !! (i-1)) ) | (c, i) <- myClassMoves]
    ]) <+> namedScratchpadManageHook myScratchPads

-- myDynamicHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
-- myDynamicHook = composeAll $
--     [
--       className =? "kitty" <&&> title =? "htop"   --> doF ( W.shift ( myWorkspaces !! 5 ) )
--     ]

-- Utility functions

centreRect = W.RationalRect 0.25 0.25 0.5 0.5

-- If the window is floating then (f), if tiled then (n)
floatOrNot f n = withFocused $ \windowId -> do
    floats <- gets (W.floating . windowset)
    if windowId `M.member` floats -- if the current window is floating...
       then f
       else n

-- Centre and float a window (retain size)
centreFloat win = do
    (_, W.RationalRect x y w h) <- floatLocation win
    windows $ W.float win (W.RationalRect ((1 - w) / 2) ((1 - h) / 2) w h)
    return ()

-- Float a window in the centre
centreFloat' w = windows $ W.float w centreRect

-- Make a window my 'standard size' (half of the screen) keeping the centre of the window fixed
standardSize win = do
    (_, W.RationalRect x y w h) <- floatLocation win
    windows $ W.float win (W.RationalRect x y 0.5 0.5)
    return ()


-- Float and centre a tiled window, sink a floating window
toggleFloat = floatOrNot (withFocused $ windows . W.sink) (withFocused centreFloat')

-- START_KEYS
myKeys :: [(String, X ())]
myKeys = concat $
        [
      -- KB_GROUP Xmonad
          [ ("M-C-r", spawn "xmonad --recompile")   -- Recompiles xmonad
          , ("M-S-r", spawn "xmonad --restart")     -- Restarts xmonad
          , ("M-<Escape>", io exitSuccess)               -- Quits xmonad

      -- KB_GROUP Get Help
          , ("M-S-/", spawn "~/.config/xmonad/xmonad_keys.sh") -- Get list of keybindings

      -- KB_GROUP Run Prompt
          , ("M-d", spawn "$HOME/.config/rofi/bin/launcher_text") -- Rofi drun menu

      -- KB_GROUP Useful programs to have a keybinding for launch
          , ("M-<Return>", spawn (myTerminal)) -- Spawn a terminal
          , ("M-b", spawn (myBrowser))          -- Open a browser
          , ("M-c", spawn "code")               -- Open VS Code

      -- KB_GROUP Kill windows
          , ("M-q",         kill1)       -- Kill the currently focused client
          , ("M-S-q", killAll)     -- Kill all windows on current workspace

      -- KB_GROUP Workspaces
          , ("M-,",         screenGo L False)                                 -- Switch focus to next monitor
          , ("M-.",         screenGo R False)                                 -- Switch focus to prev monitor
          , ("M-S-,", do { windowToScreen L False; screenGo L False })  -- Shifts focused window to next monitor
          , ("M-S-.", do { windowToScreen R False; screenGo R False })  -- Shifts focused window to prev monitor

      -- KB_GROUP Floating windows
          , ("M-f",         toggleFloat)                       -- Toggle floating for focused window
          , ("M-S-f", sendMessage (T.Toggle "floats"))   -- Toggles my 'floats' layout
          , ("M-t",         withFocused $ windows . W.sink)    -- Push floating window back to tile
          , ("M-S-t", sinkAll)                           -- Push ALL floating windows to tile

      -- KB_GROUP Increase/decrease spacing (gaps)
          , ("C-M1-j", decWindowSpacing 4)         -- Decrease window spacing
          , ("C-M1-k", incWindowSpacing 4)         -- Increase window spacing
          , ("C-M1-h", decScreenSpacing 4)         -- Decrease screen spacing
          , ("C-M1-l", incScreenSpacing 4)         -- Increase screen spacing

      -- KB_GROUP Grid Select (CTR-g followed by a key)
          , ("C-g t", goToSelected $ mygridConfig myColorizer)  -- goto selected window
          , ("C-g b", bringSelected $ mygridConfig myColorizer) -- bring selected window

      -- KB_GROUP Windows navigation
          , ("M-M1-<Space>", switchLayer)                         -- Switch between tiled/floating layer
          , ("M-h",         windowGo L False)                    -- Move focus left
          , ("M-j",         windowGo D False)                    -- Move focus down
          , ("M-k",         windowGo U False)                    -- Move focus up
          , ("M-l",         windowGo R False)                    -- Move focus right
          , ("M-n",         windows W.focusDown)                 -- Focus previous window
          , ("M-p",         windows W.focusUp)                   -- Focus next window
          , ("M1-<Tab>", nextMatch History (return True))     -- Focus most recent window
          , ("M-<Tab>", nextMatchWithThis History className) -- Focus most recent window of same class
          , ("M-S-h", windowSwap L False)                  -- Swap focused window left
          , ("M-S-j", windowSwap D False)                  -- Swap focused window down
          , ("M-S-k", windowSwap U False)                  -- Swap focused window up
          , ("M-S-l", windowSwap R False)                  -- Swap focused window right
          , ("M-C-<Return>", promote)                             -- Moves focused window to master, others maintain order
          , ("M-S-<Tab>", rotSlavesDown)                       -- Rotate all windows except master and keep focus in place
          , ("M-C-<Tab>", rotAllDown)                          -- Rotate all the windows in the current stack

      -- KB_GROUP Layouts
          , ("M-<Space>", sendMessage NextLayout)                                     -- Switch to next layout
          , ("M-C-<Space>", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full

      -- KB_GROUP Increase/decrease windows in the master pane or the stack
          , ("M-S-<Up>", sendMessage (IncMasterN 1))      -- Increase # of clients master pane
          , ("M-S-<Down>", sendMessage (IncMasterN (-1)))   -- Decrease # of clients master pane
          , ("M-C-<Up>", increaseLimit)                   -- Increase # of windows
          , ("M-C-<Down>", decreaseLimit)                   -- Decrease # of windows

      -- KB_GROUP Window resizing
          , ("M-C-h", sendMessage Shrink)                -- Shrink horiz window width
          , ("M-C-l", sendMessage Expand)                -- Expand horiz window width
          , ("M-C-j", sendMessage MirrorShrink)          -- Shrink vert window width
          , ("M-C-k", sendMessage MirrorExpand)          -- Expand vert window width

      -- KB_GROUP Sublayouts
      -- This is used to push windows to tabbed sublayouts, or pull them out of it.
          , ("M-M1-h", sendMessage $ pullGroup L)              -- Pull left window into tab group
          , ("M-M1-l", sendMessage $ pullGroup R)              -- Pull right window into tab group
          , ("M-M1-k", sendMessage $ pullGroup U)              -- Pull above window into tab group
          , ("M-M1-j", sendMessage $ pullGroup D)              -- Pull below window into tab group
          , ("M-M1-m", withFocused (sendMessage . MergeAll))   -- Merge all windows into tab group
          , ("M-M1-u", withFocused (sendMessage . UnMerge))    -- Unmerge focused window
          , ("M-M1-/", withFocused (sendMessage . UnMergeAll)) -- Unmerge all windows
          , ("M-M1-,", onGroup W.focusUp')                     -- Switch focus to next tab
          , ("M-M1-.", onGroup W.focusDown')                   -- Switch focus to prev tab

      -- KB_GROUP Scratchpads
      -- Toggle show/hide these programs.  They run on a hidden workspace.
      -- When you toggle them to show, it brings them to your current workspace.
      -- Toggle them to hide and it sends them back to hidden workspace (NSP).
          , ("M-s t", namedScratchpadAction myScratchPads "terminal") -- Terminal scratchpad
          , ("M-s p", namedScratchpadAction myScratchPads "python")   -- IPython scratchpad

      -- KB_GROUP Multimedia Keys
          , ("<XF86AudioPlay>",          spawn "playerctl -a play-pause")                -- Toggle playback
          , ("<XF86AudioMute>",          spawn "amixer set Master toggle")               -- Toggle mute
          , ("<XF86AudioLowerVolume>",  spawn "amixer set Master 5%- unmute")           -- Volume down
          , ("<XF86AudioRaiseVolume>",  spawn "amixer set Master 5%+ unmute")           -- Volume up
          , ("<XF86MonBrightnessDown>",  spawn "/home/gustav/.local/bin/brightness - 5") -- Brightness down
          , ("<XF86MonBrightnessUp>",  spawn "/home/gustav/.local/bin/brightness + 5") -- Brightness up
          ]
-- END_KEYS
        , [("M-S-C-" ++ show k, windows $ W.greedyView i . W.shift i) | (k, i) <- zip [1..9] myWorkspaces]
        ]
    -- The following lines are needed for named scratchpads.
          where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
                nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))
      

myNavigation2DConfig = def { 
        defaultTiledNavigation = hybridOf sideNavigation centerNavigation
      , floatNavigation        = hybridOf lineNavigation centerNavigation
      }

main :: IO ()
main = do
    -- Launching three instances of xmobar on their monitors.
    xmproc0 <- spawnPipe ("xmobar -x 0 $HOME/.config/xmobar/" ++ colorScheme ++ "-xmobarrc-main")
    xmproc1 <- spawnPipe ("xmobar -x 1 $HOME/.config/xmobar/" ++ colorScheme ++ "-xmobarrc")
    xmproc2 <- spawnPipe ("xmobar -x 2 $HOME/.config/xmobar/" ++ colorScheme ++ "-xmobarrc")
    -- the xmonad, ya know...what the WM is named after!
    xmonad $ docks $ withNavigation2DConfig myNavigation2DConfig $ ewmhFullscreen $ ewmh def
        { manageHook         = myManageHook <+> manageDocks <+> manageSpawn
        -- , handleEventHook    = dynamicPropertyChange "WM_NAME" myDynamicHook
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = showWName' myShowWNameTheme $ myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
        , logHook = (dynamicLogWithPP $ XMonad.Hooks.StatusBar.PP.filterOutWsPP [scratchpadWorkspaceTag] $ xmobarPP
              -- XMOBAR SETTINGS
              { ppOutput = \x -> hPutStrLn xmproc0 x   -- xmobar on monitor 1
                              >> hPutStrLn xmproc1 x   -- xmobar on monitor 2
                              >> hPutStrLn xmproc2 x   -- xmobar on monitor 3
                -- Current workspace
              , ppCurrent = xmobarColor color03 "" . wrap
                            ("<box type=Bottom width=2 mb=2 color=" ++ color03 ++ ">") "</box>"
                -- Visible but not current workspace
              , ppVisible = xmobarColor color03 "" . clickable
                -- Hidden workspace
              , ppHidden = xmobarColor color05 "" . wrap
                           ("<box type=Top width=2 mt=2 color=" ++ color05 ++ ">") "</box>" . clickable
                -- Hidden workspaces (no windows)
              , ppHiddenNoWindows = xmobarColor color05 ""  . clickable
                -- Title of active window
              , ppTitle = xmobarColor color16 "" . shorten 60
                -- Separator character
              , ppSep =  "<fc=" ++ color09 ++ "> <fn=1>|</fn> </fc>"
                -- Urgent workspace
              , ppUrgent = xmobarColor color02 "" . wrap "!" "!"
                -- Adding # of windows on current workspace to the bar
              , ppExtras  = [windowCount]
                -- order of things in xmobar
              , ppOrder  = \(ws:l:t:ex) -> ["<fn=4>"++ws++"</fn>",l]++ex++[t]
              }) <+> historyHook
        } `additionalKeysP` myKeys

