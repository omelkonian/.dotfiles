import XMonad
import qualified XMonad.StackSet as W
import XMonad.Layout.ResizableTile
import XMonad.Layout.NoBorders
import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Circle
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Fullscreen
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Util.NamedWindows
import XMonad.Actions.SpawnOn
import XMonad.Actions.Plane
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.RotSlaves (rotAllUp)
import XMonad.Actions.CycleWS (nextWS, prevWS, nextScreen, prevScreen)
import XMonad.Actions.GroupNavigation
import XMonad.Actions.Navigation2D (navigation2D, windowGo, windowSwap)
import XMonad.Actions.FlexibleResize as Flex
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.SetWMName

import Data.Default (def)
import qualified Data.Map as M
import Data.Ratio ((%))
import Graphics.X11.ExtraTypes.XF86


myModMask            = mod1Mask       -- changes the mod key to "alt"
myFocusedBorderColor = "#ff0000"      -- color of focused border
myNormalBorderColor  = "#cccccc"      -- color of inactive border
myBorderWidth        = 2              -- width of border around windows
myTerminal           = "terminator"   -- which terminal software to use

myTitleColor     = "#eeeeee"  -- color of window title
myTitleLength    = 80         -- truncate window title to this length
myCurrentWSColor = "#e6744c"  -- color of active workspace
myVisibleWSColor = "#c185a7"  -- color of inactive workspace
myUrgentWSColor  = "#cc0000"  -- color of workspace with 'urgent' window
myCurrentWSLeft  = "["        -- wrap active workspace with these
myCurrentWSRight = "]"
myVisibleWSLeft  = "("        -- wrap inactive workspace with these
myVisibleWSRight = ")"
myUrgentWSLeft  = "{"         -- wrap urgent workspace with these
myUrgentWSRight = "}"

myWorkspaces =
  [ "1:Mail",   "2:Files",   "3:Edit"
  , "4:Term",   "5:Dev",     "6:Web"
  , "7:Chat",   "8:Video",  "9:Music"
  , "0:PDF",    "Extr1",     "Extr2"
  ]

numPadKeys =
  [ xK_KP_End, xK_KP_Down, xK_KP_Page_Down
  , xK_KP_Left, xK_KP_Begin,xK_KP_Right
  , xK_KP_Home, xK_KP_Up, xK_KP_Page_Up
  , xK_KP_Insert, xK_KP_Delete, xK_KP_Enter
  ]

startupWorkspace = "None" --"4:Term"

defaultLayouts = smartBorders $ avoidStruts $ -- modifiers
  tall ||| Mirror tall ||| noBorders Full ||| Grid -- options
  where tall = ResizableTall 1 (3/100) (1/2) []

myLayouts =
  {-onWorkspace "7:Chat" chatLayout $-} defaultLayouts

-- ProTip: Use xprop to get class names
myManagementHooks :: [ManageHook]
myManagementHooks = [
  appName =? "synapse" --> doIgnore
  , appName =? "stalonetray" --> doIgnore
  , appName =? "zenity" --> doFloat
  , className =? "skype" --> doF (W.shift "7:Chat")
  , className =? "Thunderbird" --> doF (W.shift "1:Mail")
  , className =? "Nautilus" --> doF (W.shift "2:Files")
  , className =? "totem" --> doF (W.shift "9:Music")
  , className =? "Subl" --> doF (W.shift "3:Edit")
  , className =? "Sublime_text" --> doF (W.shift "3:Edit")
  , className =? "Atom" --> doF (W.shift "5:Dev")
  , className =? "Google-chrome" --> doF (W.shift "6:Web")
  , className =? "Evince" --> doF (W.shift "0:PDF")
  , className =? "Eog" --> doF (W.shift "0:PDF")
  , className =? "vlc" --> doF (W.shift "8:Video")
  , className =? "totem" --> doF (W.shift "8:Video")
  ]



-- Spawn process with a confirm dialog
confirmSpawn msg cmd = spawn $ "zenity --question --text \"Are you sure you want to " ++ msg ++  "?\" && " ++ cmd

-- Sound control
soundCard = "alsa_output.usb-Focusrite_Audio_Engineering_Saffire_6USB-00.analog-surround-40"
soundCardBuiltin = "alsa_output.pci-0000_00_1b.0.analog-stereo"
setVolume mod = "~/.xmonad/set_volume.sh " ++ mod

myKeys =
  [
    ((myModMask, xK_b), sendMessage ToggleStruts)
    , ((myModMask, xK_h), sendMessage Shrink)
    , ((myModMask, xK_l), sendMessage Expand)
    , ((myModMask, xK_a), sendMessage MirrorShrink)
    , ((myModMask, xK_z), sendMessage MirrorExpand)
    -- Kill
    , ((myModMask, xK_c), kill)
    -- Launcher
    , ((myModMask, xK_p), spawn "synapse")
    -- Specifix apps
    , ((myModMask, xK_i), spawn "google-chrome-stable")
    , ((myModMask, xK_s), spawn "subl")
    , ((myModMask, xK_f), spawn "nautilus --new-window")
    -- Focus
    , ((myModMask, xK_u), focusUrgent)
    -- Lock
    , ((myModMask .|. shiftMask, xK_l), spawn "slock")
    -- Shutdown/Restart
    , ((myModMask .|. shiftMask, xK_F11), confirmSpawn "restart" "notify-send \"OS Alert\" \"Restarting...\" && sleep 2 && shutdown -r now")
    , ((myModMask .|. shiftMask, xK_F12), confirmSpawn "shutdown"  "notify-send \"OS Alert\" \"Shutting down...\" && sleep 2 && shutdown -h now")
    -- Group navigation
    , ((myModMask, xK_space), nextWS)
    , ((myModMask .|. shiftMask, xK_space), prevWS)
    , ((myModMask, xK_grave), rotAllUp)
    , ((myModMask, xK_Tab), nextMatch History (return True))
    -- Volume (desktop keyboard)
    , ((myModMask, xK_Page_Down), spawn $ setVolume "-5%")
    , ((myModMask, xK_Page_Up), spawn $ setVolume "+5%")
    -- Volume (laptop keyboard)
    , ((0, xF86XK_AudioMute), spawn $ setVolume "0%")
    , ((0, xF86XK_AudioLowerVolume), spawn $ setVolume "-5%")
    , ((0, xF86XK_AudioRaiseVolume), spawn $ setVolume "+5%")
    -- Brightness
    , ((0, xF86XK_MonBrightnessUp), spawn "xbacklight + 20")
    , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight - 20")
  ]
  ++
  [
    ((m .|. myModMask, k), windows $ f i)
       | (i, k) <- zip myWorkspaces numPadKeys
       , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
  ] ++
  M.toList (planeKeys myModMask (Lines 4) Finite) ++
  [
    ((m .|. myModMask, key), screenWorkspace sc
      >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_w, xK_e, xK_r] [0, 1, 2]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
  ]

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [ -- Left-click, Float window and move by dragging
    ((myModMask, button1), (\w -> focus w >> mouseMoveWindow w))
    -- Right-click, Resize floating window
  , ((myModMask, button3), (\w -> focus w >> Flex.mouseResizeWindow w))
    -- Scroll, Resize slaves
  , ((myModMask, button4), const $ sendMessage MirrorExpand)
  , ((myModMask, button5), const $ sendMessage MirrorShrink)
    -- Scroll-click, Unfloat window
  , ((myModMask, button2), const $ withFocused $ windows . W.sink)
  ]

-- Loghook
myBitmapsDir = "/home/orestis/.xmonad/dzen2"
myLogHook h = dynamicLogWithPP $ def
    {
        ppCurrent           =   dzenColor "#ebac54" "#1B1D1E" . pad
      , ppVisible           =   dzenColor "white" "#1B1D1E" . pad
      , ppHidden            =   dzenColor "white" "#1B1D1E" . pad
      , ppHiddenNoWindows   =   dzenColor "#7b7b7b" "#1B1D1E" . pad
      , ppUrgent            =   dzenColor "#ff0000" "#1B1D1E" . pad
      , ppWsSep             =   " "
      , ppSep               =   "  |  "
      , ppLayout            =   dzenColor "#ebac54" "#1B1D1E" .
                                (\x -> case x of
                                    "ResizableTall" -> "^i(" ++ myBitmapsDir ++ "/tall.xbm)"
                                    "Mirror ResizableTall" -> "^i(" ++ myBitmapsDir ++ "/mtall.xbm)"
                                    "Full" -> "^i(" ++ myBitmapsDir ++ "/full.xbm)"
                                    "Simple Float" -> "~"
                                    _ -> x
                                )
      , ppTitle             =   (" " ++) . dzenColor "white" "#1B1D1E" . dzenEscape
      , ppOutput            =   hPutStrLn h
    }

-- Status bars
myXmonadBar = "dzen2 -p -xs 0 -ta 'l' -fg '#FFFFFF' -bg '#1B1D1E'"
myStatusBar = "conky -c /home/orestis/.xmonad/.conky_dzen | dzen2 -p -xs 1 -ta 'r' -fg '#FFFFFF' -bg '#1B1D1E'"

-- Notifications
myUrgencyHook = NoUrgencyHook

-- Navigation
navigation :: XConfig l -> XConfig l
navigation = navigation2D
  def -- default configuration
  (xK_Up, xK_Left, xK_Down, xK_Right) -- direction keys (U, L, D, R)
  [ -- modifiers -> actions
    (myModMask .|. shiftMask, windowGo),
    (myModMask .|. controlMask .|. shiftMask, windowSwap)
  ]
  True -- wrapping flag

-- Glue all them up.
main = do
  xmproc <- spawnPipe "xmobar"
  xmonad
    $ navigation
    $ withUrgencyHook myUrgencyHook
    $ def {
      focusedBorderColor = myFocusedBorderColor
    , normalBorderColor = myNormalBorderColor
    , terminal = myTerminal
    , borderWidth = myBorderWidth
    , layoutHook = myLayouts
    , workspaces = myWorkspaces
    , modMask = myModMask
    , mouseBindings = myMouseBindings
    , handleEventHook = fullscreenEventHook
    , startupHook = do
        setWMName "LG3D"
        windows $ W.greedyView startupWorkspace
        spawn "~/.xmonad/startup-hook"
    , manageHook =
        manageSpawn
        <+> manageHook def
        <+> composeAll myManagementHooks
        <+> manageDocks
    , logHook = dynamicLogWithPP xmobarPP {
        ppOutput = hPutStrLn xmproc
        , ppTitle = xmobarColor myTitleColor "" -- . shorten myTitleLength
        , ppCurrent = xmobarColor myCurrentWSColor ""
          . wrap myCurrentWSLeft myCurrentWSRight
        , ppVisible = xmobarColor myVisibleWSColor ""
          . wrap myVisibleWSLeft myVisibleWSRight
        , ppUrgent = xmobarColor myUrgentWSColor ""
          . wrap myUrgentWSLeft myUrgentWSRight
      } <+> historyHook
    }
    `additionalKeys` myKeys
    `removeKeys` ([(myModMask, n) | n <- [xK_Left, xK_Right, xK_Up, xK_Down]]
                  ++ [(myModMask, xK_Return)])
