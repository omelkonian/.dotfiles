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
myTitleLength    = 50         -- truncate window title to this length
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
  clickable . (map xmobarEscape) $
    [ "1:Mail",   "2:Files",   "3:Edit"
    , "4:Term",   "5:Dev",     "6:Web"
    , "7:Chat",   "8:Video",  "9:Music"
    , "0:PDF"
    ]
    where clickable l =
            [ "<action=xdotool key alt+" ++ show i ++ ">" ++ ws ++ "</action>" |
              (i,ws) <- zip ([1..9] ++ [0]) l
            ]
          xmobarEscape = concatMap doubleLts
          doubleLts '<' = "<<"
          doubleLts x   = [x]

indexWs i = myWorkspaces !! (i - 1)

numPadKeys =
  [ xK_KP_End, xK_KP_Down, xK_KP_Page_Down
  , xK_KP_Left, xK_KP_Begin,xK_KP_Right
  , xK_KP_Home, xK_KP_Up, xK_KP_Page_Up
  , xK_KP_Insert, xK_KP_Delete, xK_KP_Enter
  ]

numKeys = [ xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9, xK_0 ]

startupWorkspace = "None" -- indexWs 4

defaultLayouts = smartBorders $ avoidStruts $ -- modifiers
  tall ||| Mirror tall ||| noBorders Full ||| Grid -- options
  where tall = ResizableTall 1 (3/100) (1/2) []

myLayouts =
  {-onWorkspace "7:Chat" chatLayout $-} defaultLayouts

-- ProTip: Use xprop to get class names
myManagementHooks :: [ManageHook]
myManagementHooks =
  [ appName   =? "synapse"         --> doIgnore
  , appName   =? "stalonetray"     --> doIgnore
  , appName   =? "zenity"          --> doFloat
  , appName   =? "Extract archive" --> doFloat

  , className =? "Pdfpc"         --> doFloat
  , className =? "skype"         --> shift 7
  , className =? "Thunderbird"   --> shift 1
  , className =? "Nautilus"      --> shift 2
  , className =? "totem"         --> shift 9
  , className =? "Subl"          --> shift 3
  , className =? "Sublime_text"  --> shift 3
  , className =? "Atom"          --> shift 5
  , className =? "Google-chrome" --> shift 6
  , className =? "Evince"        --> shift 10
  , className =? "Eog"           --> shift 10
  , className =? "vlc"           --> shift 8
  , className =? "totem"         --> shift 8
  , className =? "Spotify"       --> shift 9
  , className =? "Slack"         --> shift 9
  ]
  where
    shift = doF . W.shift . indexWs

-- Spawn process with a confirm dialog
confirmSpawn msg cmd = spawn $ "zenity --question --text \"Are you sure you want to " ++ msg ++  "?\" && " ++ cmd

-- Sound control
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
    -- Mousepad
    , ((myModMask .|. shiftMask, xK_m), spawn "~/.xmonad/toggle_mousepad.sh")
    -- Scroll-click emulation
    , ((myModMask .|. shiftMask, xK_u), withFocused $ windows . W.sink)
  ]
  ++
  [
    ((m .|. myModMask, k), windows $ f i)
       | (i, k) <- zip myWorkspaces numPadKeys
       , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
  ] ++
  [
    ((m .|. myModMask, k), windows $ f i)
       | (i, k) <- zip myWorkspaces numKeys
       , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
  ] ++
  M.toList (planeKeys myModMask (Lines 4) Finite) ++
  [
    ((m .|. myModMask, key), screenWorkspace sc
      >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_w, xK_e, xK_r] [0, 1, 2]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
  ]

myMouseBindings _ = M.fromList
  [ -- Left-click, Float window and move by dragging
    ((myModMask, button1), \w -> focus w >> mouseMoveWindow w)
    -- Right-click, Resize floating window
  , ((myModMask, button3), \w -> focus w >> Flex.mouseResizeWindow w)
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
    $ docks
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
        , ppTitle = xmobarColor myTitleColor "" . shorten myTitleLength
        , ppCurrent = xmobarColor myCurrentWSColor "" . wrap myCurrentWSLeft myCurrentWSRight
        , ppVisible = xmobarColor myVisibleWSColor "" . wrap myVisibleWSLeft myVisibleWSRight
        , ppUrgent = xmobarColor myUrgentWSColor "" . wrap myUrgentWSLeft myUrgentWSRight
        , ppSep = " | "
        , ppLayout = const ""
      } <+> historyHook
    }
    `additionalKeys` myKeys
    `removeKeys` ([(myModMask, n) | n <- [xK_Left, xK_Right, xK_Up, xK_Down]]
                  ++ [(myModMask, xK_Return)])
