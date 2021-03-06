{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TypeApplications #-}

import Data.Default   (def)
import qualified Data.Map  as M
import qualified Data.Char as C

import XMonad
  ( X
  , XConfig (..)
  , xmonad
  , Window, WorkspaceId
  , Layout (..)
  , ManageHook
  , spawn--, whenJust
  , ButtonMask, Button, button1, button2, button3, button4, button5
  , (<+>), (.|.), (-->), (=?)
  , KeyMask, mod1Mask, shiftMask--, controlMask
  , KeySym
  , Typeable, ExtensionClass, initialValue, extensionType, StateExtension (..)
  , xK_Left, xK_Right, xK_Up, xK_Down, xK_Return, xK_space
  , xK_Page_Up, xK_Page_Down, xK_Home, xK_End, xK_Insert, xK_Delete
  , xK_a, xK_b, xK_c, {-xK_e,-} xK_f, xK_h, xK_i, xK_l, xK_m, xK_p--, xK_r
  , xK_s, xK_u, {-xK_w,-} xK_z, xK_Tab, xK_F11, xK_F12
  , xK_0, xK_1, xK_9
  )
import qualified Graphics.X11.ExtraTypes.XF86 as X11
import qualified XMonad                        as X
import qualified XMonad.StackSet               as W
import qualified XMonad.Actions.FlexibleResize as Flex
import qualified XMonad.Util.ExtensibleState   as XS
import XMonad.Operations              (focus, mouseMoveWindow, sendMessage, kill, windows, withFocused)--, screenWorkspace)
import XMonad.Layout                  (Resize (..), Mirror (..), Full (..), (|||), ChangeLayout (..))
import XMonad.Layout.ResizableTile    (ResizableTall (..), MirrorResize (..))
import XMonad.Layout.NoBorders        (noBorders, smartBorders)
import XMonad.Layout.Fullscreen       (fullscreenEventHook)
import XMonad.Layout.PerWorkspace     (onWorkspaces)
import XMonad.ManageHook              (composeAll, doIgnore, doFloat, doF, appName, className, liftX)
import XMonad.Hooks.DynamicLog        (PP (..), wrap, shorten, dynamicLogWithPP, xmobarPP, xmobarColor)
import XMonad.Hooks.EwmhDesktops      (ewmh)
import XMonad.Hooks.ManageDocks       (manageDocks, docks, avoidStruts, ToggleStruts (..))
import XMonad.Hooks.ManageHelpers     (doFullFloat, isFullscreen, isDialog, doCenterFloat)
import XMonad.Hooks.UrgencyHook       (withUrgencyHook, NoUrgencyHook (..), focusUrgent)
import XMonad.Hooks.SetWMName         (setWMName)
import XMonad.Util.EZConfig           (additionalKeys, removeKeys)
import XMonad.Util.Run                (spawnPipe, hPutStrLn, runProcessWithInput)
import XMonad.Actions.SpawnOn         (manageSpawn)
import XMonad.Actions.GroupNavigation (Direction (..), historyHook, nextMatch)
-- import XMonad.Actions.Plane           (planeKeys, Lines (..), Limits (..))
-- import XMonad.Actions.Navigation2D    (navigation2D, windowGo, windowSwap)

-- | Main configuration.
main :: IO ()
main = do
  xmproc <- spawnPipe "xmobar"
  xmonad
    $ ewmh
    $ docks
    -- $ navigation
    $ withUrgencyHook myUrgencyHook
    $ def {
      focusedBorderColor = myFocusedBorderColor
    , normalBorderColor  = myNormalBorderColor
    , terminal           = myTerminal
    , borderWidth        = myBorderWidth
    , layoutHook         = myLayouts
    , workspaces         = myWorkspaces
    , modMask            = alt
    , mouseBindings      = myMouseBindings
    , handleEventHook    = fullscreenEventHook
    , startupHook        = do setWMName "LG3D"
                              -- windows $ W.greedyView (ws 1)
                              spawn "~/.xmonad/startup-hook"
    , manageHook         = manageSpawn
                       <+> manageHook def
                       <+> composeAll myManagementHooks
                       <+> manageDocks
    , logHook            = dynamicLogWithPP (pp xmproc)
                       <+> historyHook
    }
    `additionalKeys` myKeys
    `removeKeys` (  [(alt, n) | n <- [xK_Left, xK_Right, xK_Up, xK_Down]]
                 ++ [(alt, xK_Return)])
  where
    pp proc = xmobarPP {
        ppOutput  = hPutStrLn proc
      , ppTitle   = xmobarColor myTitleColor ""
                  . shorten myTitleLength
      , ppCurrent = xmobarColor myCurrentWSColor ""
                  . wrap myCurrentWSLeft myCurrentWSRight
      , ppVisible = xmobarColor myVisibleWSColor ""
                  . wrap myVisibleWSLeft myVisibleWSRight
      , ppUrgent  = xmobarColor myUrgentWSColor ""
                  . wrap myUrgentWSLeft myUrgentWSRight
      , ppSep     = " | "
      , ppLayout  = xmobarColor myLayoutColor ""
      }

-------------------------------------------------------
-- Styling.

myFocusedBorderColor = "#ff0000"      -- color of focused border
myNormalBorderColor  = "#cccccc"      -- color of inactive border
myBorderWidth        = 2              -- width of border around windows
myTerminal           = "terminator"   -- which terminal software to use

myTitleColor     = "#eeeeee"  -- color of window title
myTitleLength    = 200        -- truncate window title to this length
myCurrentWSColor = "#e6744c"  -- color of active workspace
myVisibleWSColor = "#c185a7"  -- color of inactive workspace
myUrgentWSColor  = "#cc0000"  -- color of workspace with 'urgent' window
myLayoutColor    = "#dddd00"  -- color of the current layout
myCurrentWSLeft  = "["        -- wrap active workspace with these
myCurrentWSRight = "]"
myVisibleWSLeft  = "("        -- wrap inactive workspace with these
myVisibleWSRight = ")"
myUrgentWSLeft   = "{"         -- wrap urgent workspace with these
myUrgentWSRight  = "}"

-------------------------------------------------------
-- Layouts.

myLayouts
  = smartBorders
  $ avoidStruts
  $ onWorkspaces (ws <$> [7..9]) fullFirst tallFirst
  where
    tall = ResizableTall 1 (3/100) (1/2) []
    full = noBorders Full

    tallFirst = tall ||| Mirror tall ||| full
    fullFirst = full ||| tall ||| Mirror tall

-------------------------------------------------------
-- Workspaces.

myWorkspaces :: [WorkspaceId]
myWorkspaces =
  clickable . (map xmobarEscape) $
    map (take 1)
    [ "1:Mail", "2:Files", "3:Edit"
    , "4:Term", "5:Dev",   "6:Web"
    , "7:Dev",  "8:Video", "9:Chat"
    , "0:PDF"
    ]
    where
      clickable l
        = [ "<action=xdotool key alt+" ++ show i ++ ">" ++ s ++ "</action>"
          | (i, s) <- zip ([1..9] ++ [0]) l
          ]
      xmobarEscape = concatMap (\case '<' -> "<<" ; x -> [x])

ws :: Int -> WorkspaceId
ws 0 = last $ myWorkspaces
ws i = myWorkspaces !! (i - 1)

-------------------------------------------------------
-- Persitent user state.
data MyState = MyState { muted :: Maybe Int } 
  deriving (Typeable, Read, Show)

instance ExtensionClass MyState where
  initialValue  = MyState Nothing
  extensionType = PersistentExtension

-------------------------------------------------------
-- Hooks.

-- Hide the bar at the top of the screen.
hideXmobar :: X ()
hideXmobar = sendMessage ToggleStruts

-- ProTip: Use xprop to get class names
myManagementHooks :: [ManageHook]
myManagementHooks =
  [ isFullscreen                   --> doFullFloat <* liftX hideXmobar
  , isDialog                       --> doCenterFloat
  , appName   =? "synapse"         --> doIgnore
  , appName   =? "stalonetray"     --> doIgnore
  , appName   =? "zenity"          --> doFloat
  , appName   =? "Extract archive" --> doFloat
  , appName   =? "Transmission"    --> goto 9
  , className =? "Pdfpc"           --> doFloat
  , className =? "Thunderbird"     --> goto 1
  , className =? "org.gnome.Nautilus" --> goto 2
  , className =? "Atom"            --> goto 5
  , className =? "TeX"             --> goto 5
  , className =? "Google-chrome"   --> goto 6
  , className =? "Firefox"         --> goto 6
  , className =? "vlc"             --> goto 8
  , className =? "totem"           --> goto 8
  , className =? "Spotify"         --> goto 9
  , className =? "Slack"           --> goto 9
  , className =? "Zulip"           --> goto 9
  -- , className =? "pcloud"          --> goto 9
  -- , className =? "pCloud"          --> goto 9
  , className =? "Evince"          --> goto 10
  , className =? "Eog"             --> goto 10
  ]
  where goto  = doF . W.shift . ws

-- Notifications
myUrgencyHook = NoUrgencyHook

-------------------------------------------------------
-- Keys.

alt, shift :: KeyMask
alt   = mod1Mask -- meta key
shift = shiftMask

myKeys :: [((KeyMask, KeySym), X ())]
myKeys =
  [ -- Layout management
    (alt, xK_space) ~>
      sendMessage NextLayout
  , (alt, xK_b) ~>
      hideXmobar
  , (alt, xK_h) ~>
      sendMessage Shrink
  , (alt, xK_l) ~>
      sendMessage Expand
  , (alt, xK_a) ~>
      sendMessage MirrorShrink
  , (alt, xK_z) ~>
      sendMessage MirrorExpand
  , (alt, xK_Tab) ~>
      nextMatch History (return True)
  -- Kill
  , (alt, xK_c) ~>
      kill
  -- Launcher
  , (alt, xK_p) ~>
      spawn "kupfer"
  -- Specifix apps
  , (alt, xK_i) ~>
      spawn "firefox"
  , (alt .|. shift, xK_i) ~>
      spawn "firefox --private-window"
  , (alt, xK_s) ~>
      spawn "subl"
  , (alt, xK_f) ~>
      spawn "nautilus --new-window"
  -- Focus
  , (alt, xK_u) ~>
      focusUrgent
  -- Lock
  , (alt .|. shift, xK_l) ~>
      spawn "slock"
  -- Shutdown/Restart
  , (alt .|. shift, xK_F11) ~>
      confirmSpawn "restart" "notify-send \"OS Alert\" \"Restarting...\" && shutdown -r now"
  , (alt .|. shift, xK_F12) ~>
      confirmSpawn "shutdown"  "notify-send \"OS Alert\" \"Shutting down...\" && shutdown -h now"
  -- Volume control
  , (0, X11.xF86XK_AudioMute) ~>
      toggleMute
  , (alt, xK_Delete) ~>
      toggleMute
  , (0, X11.xF86XK_AudioLowerVolume) ~>
      spawn (audioCtrl "set_volume -5%")
  , (alt, xK_Page_Down) ~>
      spawn (audioCtrl "set_volume -5%")
  , (0, X11.xF86XK_AudioRaiseVolume) ~>
      spawn (audioCtrl "set_volume +5%")
  , (alt, xK_Page_Up) ~>
      spawn (audioCtrl "set_volume +5%")
  -- Music controls
  , (0, X11.xF86XK_AudioPlay) ~>
      spawn (audioCtrl "play/pause")
  , (alt, xK_Insert) ~>
      spawn (audioCtrl "play/pause")
  , (0, X11.xF86XK_AudioNext) ~>
      spawn (audioCtrl "next")
  , (alt, xK_End) ~>
      spawn (audioCtrl "next")
  , (0, X11.xF86XK_AudioPrev) ~>
      spawn (audioCtrl "prev")
  , (alt, xK_Home) ~>
      spawn (audioCtrl "prev")
  -- Brightness
  , (0, X11.xF86XK_MonBrightnessUp) ~>
      spawn (screenCtrl "brighten")
  , (0, X11.xF86XK_MonBrightnessDown) ~>
      spawn (screenCtrl "darken")
  , (alt .|. shift, xK_s) ~>
      spawn (screenCtrl "setupScreens")
  -- Mousepad
  , (alt .|. shift, xK_m) ~>
      spawn "~/.xmonad/scripts/toggle_mousepad.sh"
  -- Scroll-click emulation
  , (alt .|. shift, xK_u) ~>
      withFocused (windows . W.sink)
  ] ++
  [ (m .|. alt, k) ~> windows (f i)
  | (i, k) <- zip myWorkspaces ([xK_1..xK_9] ++ [xK_0])
  , (f, m) <- [(W.greedyView, 0), (W.shift, shift)]
  ]
  where
    (~>) = (,)

    -- | mute/unmute
    toggleMute :: X ()
    toggleMute = do      
      s <- XS.get
      X.trace ("state: " ++ show s)
      case muted s of
        Nothing -> do
          ret <- runProcessWithInput "/home/omelkonian/.xmonad/scripts/audio_controls.sh" ["get_volume"] ""
          X.trace ("ret: " ++ ret)
          let n = read @Int $ filter C.isNumber ret
          X.trace ("getVolume: " ++ show n ++ "%")
          XS.put $ s {muted = Just n}
          spawn $ audioCtrl "set_volume 0%"
        Just n  -> do
          XS.put $ s {muted = Nothing}
          spawn $ audioCtrl ("set_volume " ++ show n ++ "%")

    -- | Spawn process with a confirm dialog.
    confirmSpawn msg cmd =
      spawn $ "zenity --question --text \"Are you sure you want to "
            ++ msg
            ++  "?\" && "
            ++ cmd

    -- | Audio control.
    audioCtrl cmd = "~/.xmonad/scripts/audio_controls.sh " ++ cmd
    -- | Screen control.
    screenCtrl cmd = "~/.xmonad/scripts/video_controls.sh " ++ cmd

myMouseBindings :: XConfig Layout -> M.Map (ButtonMask, Button) (Window -> X ())
myMouseBindings _ = M.fromList
  [ -- Left-click, Float window and move by dragging
    ((alt, button1), \w -> focus w >> mouseMoveWindow w)
    -- Right-click, Resize floating window
  , ((alt, button3), \w -> focus w >> Flex.mouseResizeWindow w)
    -- Scroll, Resize slaves
  , ((alt, button4), const $ sendMessage MirrorExpand)
  , ((alt, button5), const $ sendMessage MirrorShrink)
    -- Scroll-click, Unfloat window
  , ((alt, button2), const $ withFocused $ windows . W.sink)
  ]
