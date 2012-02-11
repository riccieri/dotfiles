import XMonad
import XMonad.Config.Desktop
import XMonad.Util.EZConfig
import XMonad.Layout.NoBorders
import XMonad.Actions.WindowGo
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Reflect
import XMonad.Layout.MultiToggle
import XMonad.Hooks.ManageDocks
import qualified XMonad.StackSet as W

insistentQuery name = appName =? name <||> title =? name <||> className =? name

myManageHook = composeAll [
    appName   =? "Synapse"        --> doFloat,
    className =? "Unity-2d-panel" --> doIgnore,
    className =? "lxpanel"        --> doIgnore,
    className =? "wicd-client.py" --> doFloat,
    isFullscreen --> doFullFloat
    ]

startup = spawn "sh ~/.xinitrc"

myLayoutHook = avoidStruts $ mkToggle (single REFLECTX) $ smartBorders $ layoutHook desktopConfig

main = xmonad $ desktopConfig {
	manageHook  = manageDocks <+> myManageHook <+> manageHook desktopConfig,
	borderWidth = 1,
	focusedBorderColor = "#00a6c5",
	focusFollowsMouse  = False,
	layoutHook  = myLayoutHook,
	startupHook  = startup,
	terminal    = "urxvt",
	modMask     = mod4Mask
    }
    `additionalKeysP` [
       ("M-p",  spawn "synapse"),
       ("M-b",  sendMessage ToggleStruts),
       ("M-v",  runOrRaise "bin/transparent_gvim"   (className =? "Gvim")),
       ("M-t",  raiseMaybe (spawn "urxvt")          (insistentQuery "Terminal")),
       ("M-g",  raise                               (insistentQuery "Guard")),
       ("M-i",  runOrRaiseNext "google-chrome"      (insistentQuery "google-chrome")),
       ("M-S-t", withFocused $ windows . W.sink),
       ("M-<Left>",  sendMessage $ Toggle REFLECTX)
     ]
