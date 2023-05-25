{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE FlexibleContexts #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}

import Data.Default (def)
import Data.List (isInfixOf)
import qualified Data.Map  as M
import qualified Data.Char as C
import Control.Applicative ( (<|>) )
import Control.Monad (liftM)

import XMonad
  ( X
  , XConfig (..)
  , xmonad
  , Window, WorkspaceId
  , Layout (..), LayoutClass, Choose
  , ManageHook
  , spawn--, whenJust
  , ButtonMask, Button, button1, button2, button3, button4, button5
  , (<+>), (.|.), (-->), (=?)
  , KeyMask, mod1Mask, shiftMask, controlMask
  , KeySym
  , Typeable, ExtensionClass, initialValue, extensionType, StateExtension (..)
  , xK_Left, xK_Right, xK_Up, xK_Down, xK_Return, xK_space
  , xK_Page_Up, xK_Page_Down, xK_Home, xK_End, xK_Insert, xK_Delete
  , xK_a, xK_b, xK_c, xK_e, xK_f, xK_g, xK_h, xK_i, xK_l, xK_m, xK_p, xK_r
  , xK_s, xK_t, xK_u, xK_w, xK_z, xK_Tab, xK_F11, xK_F12
  , xK_0, xK_1, xK_9
  )
import qualified Graphics.X11.ExtraTypes.XF86 as X11
import qualified XMonad                        as X
import qualified XMonad.StackSet               as W
import qualified XMonad.Actions.FlexibleResize as Flex
import qualified XMonad.Util.ExtensibleState   as XS
import XMonad.Operations              (focus, mouseMoveWindow, sendMessage, kill, windows, withFocused)--, screenWorkspace)

import XMonad.Layout                  (Resize (..), Mirror (..), Full (..), (|||), ChangeLayout (..))
import XMonad.Layout.LayoutModifier   (ModifiedLayout)
import XMonad.Layout.ResizableTile    (ResizableTall (..), MirrorResize (..))
import XMonad.Layout.NoBorders        (noBorders, smartBorders, SmartBorder, WithBorder)
import XMonad.Layout.Fullscreen       (fullscreenEventHook)
import XMonad.Layout.PerWorkspace     (onWorkspace, onWorkspaces)
import XMonad.Layout.PerScreen        (ifWider, PerScreen)

import XMonad.ManageHook              (composeAll, doIgnore, doFloat, doF, appName, className, appName, liftX, (<||>), (<&&>))
import XMonad.Hooks.DynamicLog        (PP (..), wrap, shorten, dynamicLogWithPP, xmobarPP, xmobarColor)
import XMonad.Hooks.EwmhDesktops      (ewmh)
import XMonad.Hooks.ManageDocks       (manageDocks, docks, avoidStruts, AvoidStruts, ToggleStruts (..))
import XMonad.Hooks.ManageHelpers     (doFullFloat, isFullscreen, isDialog, doCenterFloat)
import XMonad.Hooks.UrgencyHook       (withUrgencyHook, NoUrgencyHook (..), focusUrgent)
import XMonad.Hooks.SetWMName         (setWMName)
import XMonad.Hooks.WorkspaceHistory (workspaceHistoryHook)

import XMonad.Util.EZConfig           (additionalKeys, removeKeys)
import XMonad.Util.Run                (spawnPipe, hPutStrLn, runProcessWithInput)

import XMonad.Actions.SpawnOn         (manageSpawn)
import XMonad.Actions.GroupNavigation (Direction (..), historyHook, nextMatch)
import XMonad.Actions.PhysicalScreens (viewScreen, sendToScreen, onPrevNeighbour, onNextNeighbour, horizontalScreenOrderer)
import XMonad.Actions.GridSelect      (goToSelected)

-- import Data.Tree (Forest, Tree (..))
-- import XMonad.Actions.TreeSelect      (treeselectWorkspace, TSConfig (..), toWorkspaces)

import XMonad.Prompt (def, XPConfig (..))
import XMonad.Actions.Launcher

import XMonad.Actions.DynamicProjects (dynamicProjects, switchProjectPrompt, Project (..))

-- import XMonad.Actions.Plane           (planeKeys, Lines (..), Limits (..))
-- import XMonad.Actions.Navigation2D    (navigation2D, windowGo, windowSwap)

-- import XMonad.Actions.MouseResize
-- import XMonad.Layout.WindowArranger   (windowArrangeAll)
-- import XMonad.Actions.MouseGestures   (mouseGesture, Direction2D (..))

-- | Main configuration.
main :: IO ()
main = do
  xmproc <- spawnPipe "xmobar"
  xmonad
    $ ewmh
    $ docks
    -- $ navigation
    $ withUrgencyHook myUrgencyHook
    $ dynamicProjects projects
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
                       <+> workspaceHistoryHook
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
      , ppSep     = " "
      , ppLayout  = xmobarColor myLayoutColor "" . layoutToIcon
      }

    layoutToIcon s
      | s == "ResizableTall" = "<icon=tall.xbm/>"
      | s == "Mirror ResizableTall" = "<icon=mtall.xbm/>"
      | s == "Full" = "<icon=full.xbm/>"
      | otherwise = s
-------------------------------------------------------
-- Styling.

-- myFont = "xft:LiberationMono:size=13:antialias=true"
myFont = "xft:Monospace-11"

myFocusedBorderColor = "#ff0000"      -- color of focused border
myNormalBorderColor  = "#cccccc"      -- color of inactive border
myBorderWidth        = 1              -- width of border around windows
myTerminal           = "terminator"   -- which terminal software to use

myTitleColor     = "#eeeeee"  -- color of window title
myTitleLength    = 15     -- truncate window title to this length
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

type F = ModifiedLayout WithBorder Full

-- myLayouts :: ModifiedLayout SmartBorder (ModifiedLayout AvoidStruts (PerScreen _ _)) Window
myLayouts
  = smartBorders
  $ avoidStruts
  $ onWorkspace (ws 1) mailFirst
  $ onWorkspaces (ws <$> [7..9]) fullFirst tallFirst
  where
    tall, mail :: ResizableTall Window
    tall = ResizableTall 1 (3/100) (1/2) []
    mail = ResizableTall 1 (3/100) (2/3) []

    full :: F Window
    full = noBorders Full

    bothScreens
      :: LayoutClass l Window
      => l Window
      -> PerScreen (Choose l (Choose (Mirror l) F)) (Choose (Mirror l) (Choose l F)) Window
    bothScreens l = ifWider 1280 (l ||| Mirror l ||| full) (Mirror l ||| l ||| full)

    fullFirst = full ||| tall ||| Mirror tall
    mailFirst = bothScreens mail
    tallFirst = bothScreens tall

-------------------------------------------------------
-- Workspaces.

workspaceIDs :: [String]
workspaceIDs = 
  [ "1:Mail", "2:Files", "3:Edit"
  , "4:Term", "5:Dev",   "6:Web"
  , "7:Dev",  "8:Video", "9:Chat"
  , "0:PDF"
  ]

-- myWorkspaceForest :: Forest String
-- myWorkspaceForest = flip Node [] <$> workspaceIDs

myWorkspaces :: [WorkspaceId]
myWorkspaces =
  clickable . (map xmobarEscape) $
    map (take 1) $
      workspaceIDs
      -- toWorkspaces myWorkspaceForest
    where
      clickable l
        = [ "<action=xdotool key alt+" ++ show i ++ ">" ++ s ++ "</action>"
          | (i, s) <- zip ([1..9] ++ [0]) l
          ]
      xmobarEscape = concatMap (\case '<' -> "<<" ; x -> [x])

ws :: Int -> WorkspaceId
ws 0 = last $ myWorkspaces
ws i = myWorkspaces !! (i - 1)

projects :: [Project]
projects =
  [ Project { projectName      = "scratch"
            , projectDirectory = "~/"
            , projectStartHook = Nothing
            }

  , Project { projectName      = "social"
            , projectDirectory = "~/"
            , projectStartHook = Just $ do spawn "slack"
                                           spawn "zulip"
            }
  ]

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
myManagementHooks = let goto = doF . W.shift . ws in
  map (\i -> classOrAppName ["at" ++ show i] --> goto i) [0..9] ++
  [ isFullscreen --> doFullFloat <* liftX hideXmobar
  , isDialog     --> doCenterFloat
  , ignor --> doIgnore
  -- , className =? "org.gnome.Nautilus" --> goto 2
  , float --> doFloat
  , mail  --> goto 1
  , net   --> goto 6
  -- , className =? "Google-chrome"   --> goto 6
  , video --> goto 8
  , tor   --> goto 9
  , music --> goto 9
  , msg   --> goto 9
  -- , className =? "pCloud"          --> goto 9
  , doc   --> goto 10
  ]
  where
    lowInfixOf :: String -> String -> Bool
    lowInfixOf x y = map C.toLower x `isInfixOf` map C.toLower y

    containsAnyOf :: X.Query String -> [String] -> X.Query Bool
    containsAnyOf _ [] = return False
    containsAnyOf q (x:xs) = fmap (x `lowInfixOf`) q <||> containsAnyOf q xs

    classOrAppName :: [String] -> X.Query Bool
    classOrAppName xs =  containsAnyOf className xs
                    <||> containsAnyOf appName   xs

    ignor, float, mail, net, video, music, doc  :: X.Query Bool
    ignor = classOrAppName ["synapse", "stalonetray"]
    float = classOrAppName ["zenity", "Extract archive", "Pdfpc"]
    mail  = classOrAppName ["thunderbird"]
    net   = classOrAppName ["Firefox"]
    video = classOrAppName ["vlc", "totem"]
    music = classOrAppName ["spotify", "rhythmbox"]
    msg   = classOrAppName ["Slack", "Zulip"]
    tor   = classOrAppName ["Transmission", "Transmission-gtk"]
    doc   = classOrAppName ["Evince", "Eog"]
            <&&> liftM not (classOrAppName ["at5"])

-- Notifications
myUrgencyHook = NoUrgencyHook

-------------------------------------------------------
-- Keys.

alt, shift, ctrl, noMask :: KeyMask
alt    = mod1Mask -- meta key
shift  = shiftMask
ctrl   = controlMask
noMask = 0
(~>) = (,)

myKeys :: [((KeyMask, KeySym), X ())]
myKeys =
  [ -- Layout management
    (alt, xK_space) ~> sendMessage NextLayout
  , (alt, xK_b) ~> hideXmobar
  , (alt, xK_h) ~> sendMessage Shrink
  , (alt, xK_l) ~> sendMessage Expand
  , (alt, xK_a) ~> sendMessage MirrorShrink
  , (alt, xK_z) ~> sendMessage MirrorExpand
  , (alt, xK_Tab) ~> nextMatch History (return True)
  -- Kill
  , (alt, xK_c) ~> kill
  -- Launcher
  , (alt, xK_p) ~> spawn "kupfer"
  -- Specifix apps
  , (alt, xK_i) ~> spawn "firefox"
  , (alt .|. shift, xK_i) ~> spawn "firefox --private-window"
  , (alt, xK_s) ~> spawn "subl"
  , (alt, xK_f) ~> spawn "nautilus --new-window"
  -- Focus
  , (alt, xK_u) ~> focusUrgent
  -- Lock
  , (alt .|. shift, xK_l) ~> spawn "slock"
  -- Shutdown/Restart
  , (alt .|. shift, xK_F11) ~> confirmSpawn "restart" "notify-send \"OS Alert\" \"Restarting...\" && shutdown -r now"
  , (alt .|. shift, xK_F12) ~> confirmSpawn "shutdown"  "notify-send \"OS Alert\" \"Shutting down...\" && shutdown -h now"
  -- Volume control
  , (noMask, X11.xF86XK_AudioMute) ~> toggleMute
  , (alt, xK_Delete) ~> toggleMute
  , (noMask, X11.xF86XK_AudioLowerVolume) ~> callFun "audio" "setSinkVolume -5%"
  , (alt, xK_Page_Down) ~> callFun "audio" "setSinkVolume -5%"
  , (noMask, X11.xF86XK_AudioRaiseVolume) ~> callFun "audio" "setSinkVolume +5%"
  , (alt, xK_Page_Up) ~> callFun "audio" "setSinkVolume +5%"
  -- Music controls
  , (noMask, X11.xF86XK_AudioPlay) ~> callFun "audio" "audio__play_pause"
  , (alt, xK_Insert) ~> callFun "audio" "audio__play_pause"
  , (noMask, X11.xF86XK_AudioNext) ~> callFun "audio" "audio__next"
  , (alt, xK_End) ~> callFun "audio" "audio__next"
  , (noMask, X11.xF86XK_AudioPrev) ~> callFun "audio" "audio__prev"
  , (alt, xK_Home) ~> callFun "audio" "audio__prev"
  -- Screen controls
  , (alt .|. shift, xK_s) ~> callFun "video" "setup_screens"
  , (alt .|. shift, xK_Left) ~> spawn "xrandr -o left"
  , (alt .|. shift, xK_Right) ~> spawn "xrandr -o normal"
  -- Brightness
  , (noMask, X11.xF86XK_MonBrightnessUp) ~> callFun "video" "changeBrightness + 20"
  , (noMask, X11.xF86XK_MonBrightnessDown) ~> callFun "video" "changeBrightness - 20"
  -- Mousepad
  , (alt .|. shift, xK_m) ~> callFun "keyboard" "touchpad__toggle"
  -- Scroll-click emulation
  , (alt .|. shift, xK_u) ~> withFocused (windows . W.sink)
  -- Launcher
  , (alt .|. ctrl, xK_l) ~> launcherPrompt (def {font = myFont, height = 20}) (defaultLauncherModes launcherConfig)
  -- Grid select
  , (alt, xK_g) ~> goToSelected def
  -- Tree select
  -- , (alt, xK_t) ~> treeselectWorkspace (def {ts_font = myFont}) myWorkspaceForest W.shift
  -- Projects
  , (alt .|. ctrl, xK_space) ~> switchProjectPrompt (def {font = myFont})
  ] ++
  -- Workspaces 
  [ (alt .|. m, k) ~> windows (f i)
  | (i, k) <- zip myWorkspaces ([xK_1..xK_9] ++ [xK_0])
  , (f, m) <- [(W.greedyView, noMask), (W.shift, shift)]
  ] ++
  -- Screens
  [ (alt .|. mask, key) ~> f horizontalScreenOrderer sc
  | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
  , (f, mask) <- [(viewScreen, noMask), (sendToScreen, shift)]
  ]

  where

    callFun :: String -> String -> X ()
    callFun s f = spawn $ "callFun.sh /home/omelkonian/git/.dotfiles/bash/" ++ s ++ ".symlink " ++ f

    xtrace :: String -> X ()
    xtrace s = X.io $ appendFile "/home/omelkonian/.xmonad/xmonad.errors" ('\n' : s)

    -- | mute/unmute
    toggleMute :: X ()
    toggleMute = do      
      s <- XS.get
      xtrace $ "state: " ++ show s
      case muted s of
        Nothing -> do
          ret <- runProcessWithInput "callFun.sh" ["/home/omelkonian/git/.dotfiles/bash/audio.symlink", "getSinkVolume"] ""
          xtrace $ "ret: " ++ ret
          let n = read @Int $ filter C.isNumber ret
          xtrace $ "getVolume: " ++ show n ++ "%"
          XS.put $ s {muted = Just n}
          callFun "audio" "setSinkVolume 0%"
        Just n  -> do
          xtrace $ "gotVolume: " ++ show n ++ "%"
          XS.put $ s {muted = Nothing}
          callFun "audio" ("setSinkVolume " ++ show n ++ "%")

    -- | Spawn process with a confirm dialog.
    confirmSpawn msg cmd =
      spawn $ "zenity --question --text \"Are you sure you want to "
            ++ msg
            ++  "?\" && "
            ++ cmd

    launcherConfig = LauncherConfig
      { pathToHoogle = "/home/omelkonian/.local/bin/hoogle"
      , browser = "/usr/bin/firefox"
      }

myMouseBindings :: XConfig Layout -> M.Map (ButtonMask, Button) (Window -> X ())
myMouseBindings _ = M.fromList
  [ -- Left-click, Float window and move by dragging
    (alt, button1) ~> \w -> focus w >> mouseMoveWindow w
    -- Right-click, Resize floating window
  , (alt, button3) ~> \w -> focus w >> Flex.mouseResizeWindow w
    -- Scroll, Resize slaves
  , (alt, button4) ~> \_ -> sendMessage MirrorExpand
  , (alt, button5) ~> \_ -> sendMessage MirrorShrink
    -- Scroll-click, Unfloat window
  , (alt, button2) ~> \_ -> withFocused (windows . W.sink)
  -- Mouse gestures
  -- , (alt .|. shift, button3) ~> mouseGesture gestures
  ]
  where
    -- gestures = M.fromList 
    --   [ ([], focus)
    --   , ([U], \w -> focus w >> windows W.swapUp)
    --   , ([D], \w -> focus w >> windows W.swapDown)
    --   , ([R, D], const $ sendMessage NextLayout)
    --   ]


