import XMonad
import XMonad.Hooks.SetWMName
import XMonad.Layout.Grid
import XMonad.Layout.ResizableTile
import XMonad.Layout.IM
import XMonad.Layout.ThreeColumns
import XMonad.Layout.NoBorders
import XMonad.Layout.Circle
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Fullscreen
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Util.NamedWindows
import XMonad.Hooks.DynamicLog
import XMonad.Actions.Plane
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.CycleWS (nextWS, prevWS, nextScreen, prevScreen)
import XMonad.Actions.SpawnOn (spawnOn)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ICCCMFocus
import qualified XMonad.StackSet as W
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
  [
    "7:Chat",   "8:Video",  "9:Music",
    "4:Term",   "5:Dev",     "6:Web",
    "1:Mail",   "2:Files",   "3:Edit",
    "0:PDF",    "Extr1",     "Extr2"
  ]

startupWorkspace = "5:Web"  -- which workspace do you want to be on after launch?

defaultLayouts = smartBorders(avoidStruts(
  ResizableTall 1 (3/100) (1/2) []
  ||| Mirror (ResizableTall 1 (3/100) (1/2) [])
  ||| noBorders Full
  ||| Grid))

myLayouts =
  {-onWorkspace "7:Chat" chatLayout $-} defaultLayouts

myManagementHooks :: [ManageHook]
myManagementHooks = [
  resource =? "synapse" --> doIgnore
  , resource =? "stalonetray" --> doIgnore
  , (className =? "skype") --> doF (W.shift "7:Chat")
  , (className =? "Thunderbird") --> doF (W.shift "1:Mail")
  , (className =? "Nautilus") --> doF (W.shift "2:Files")
  , (className =? "totem") --> doF (W.shift "9:Music")
  , (className =? "Sublime_text") --> doF (W.shift "3:Edit")
  , (className =? "google-chrome") --> doF (W.shift "6:Web")
  , (className =? "Evince") --> doF (W.shift "0:PDF")
  , (className =? "Vlc") --> doF (W.shift "8:Video")
  ]

numPadKeys =
  [
    xK_KP_Home, xK_KP_Up, xK_KP_Page_Up
    , xK_KP_Left, xK_KP_Begin,xK_KP_Right
    , xK_KP_End, xK_KP_Down, xK_KP_Page_Down
    , xK_KP_Insert, xK_KP_Delete, xK_KP_Enter
  ]

myKeys =
  [
    ((myModMask, xK_b), sendMessage ToggleStruts)
    , ((myModMask, xK_a), sendMessage MirrorShrink)
    , ((myModMask, xK_z), sendMessage MirrorExpand)
    , ((myModMask, xK_p), spawn "synapse")
    , ((myModMask, xK_u), focusUrgent)
    , ((myModMask .|. shiftMask, xK_P), spawnOn "9:Music" "google-chrome --new-window play.spotify.com")
    , ((myModMask, xK_F10), spawn "amixer -q set Master toggle")
    , ((myModMask, xK_Page_Down), spawn "amixer -q set Master 2%-")
    , ((myModMask, xK_Page_Up), spawn "amixer -q set Master 2%+")
    , ((myModMask .|. shiftMask, xK_l), spawn "slock")
    , ((myModMask .|. shiftMask, xK_F11), spawn "notify-send \"OS Alert\" \"Restarting...\" && shutdown -r now")
    , ((myModMask .|. shiftMask, xK_F12), spawn "notify-send \"OS Alert\" \"Shutting down...\" && shutdown -h now")
    , ((myModMask, xK_Escape), spawn "/home/orestis/.xmonad/lang_switch.sh")
    , ((myModMask, xK_space), nextWS)
    , ((myModMask .|. shiftMask, xK_space), prevWS)
    , ((myModMask, xK_c), kill)
    , ((0, xF86XK_MonBrightnessUp), spawn "/etc/acpi/asus-keyboard-backlight.sh up")
    , ((0, xF86XK_MonBrightnessDown), spawn "/etc/acpi/asus-keyboard-backlight.sh down")
    , ((0, xF86XK_AudioLowerVolume), spawn "amixer -q set Master 3%-")
    , ((0, xF86XK_AudioRaiseVolume), spawn "amixer -q set Master 3%+")
    , ((0, xF86XK_AudioMute), spawn "amixer -q set Master 0")
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

-- Loghook
myBitmapsDir = "/home/orestis/.xmonad/dzen2"
myLogHook h = dynamicLogWithPP $ defaultPP
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
myUrgencyHook = NoUrgencyHook -- dzenUrgencyHook { args = ["-bg", "darkgreen", "-xs", "1"] }

-- Glue all them up.
main = do
  -- dzenLeftBar <- spawnPipe myStatusBar
  xmproc <- spawnPipe "xmobar"
  xmonad $ withUrgencyHook myUrgencyHook $ defaultConfig {
    focusedBorderColor = myFocusedBorderColor
  , normalBorderColor = myNormalBorderColor
  , terminal = myTerminal
  , borderWidth = myBorderWidth
  , layoutHook = myLayouts
  , workspaces = myWorkspaces
  , modMask = myModMask
  , handleEventHook = fullscreenEventHook
  , startupHook = do
      setWMName "LG3D"
      windows $ W.greedyView startupWorkspace
      spawn "~/.xmonad/startup-hook"
  , manageHook = manageHook defaultConfig
      <+> composeAll myManagementHooks
      <+> manageDocks
  , logHook = takeTopFocus <+> dynamicLogWithPP xmobarPP {
      ppOutput = hPutStrLn xmproc
      , ppTitle = xmobarColor myTitleColor "" -- . shorten myTitleLength
      , ppCurrent = xmobarColor myCurrentWSColor ""
        . wrap myCurrentWSLeft myCurrentWSRight
      , ppVisible = xmobarColor myVisibleWSColor ""
        . wrap myVisibleWSLeft myVisibleWSRight
      , ppUrgent = xmobarColor myUrgentWSColor ""
        . wrap myUrgentWSLeft myUrgentWSRight
    }
                -- myLogHook dzenLeftBar >> fadeInactiveLogHook 0xeeeeeeee
  }
    `additionalKeys` myKeys
    `removeKeys` ([(myModMask, n) | n <- [xK_1 .. xK_9] ++ [xK_Left, xK_Right, xK_Up, xK_Down]]
                  ++ [(myModMask, xK_Return)])
