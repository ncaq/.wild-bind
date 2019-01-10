{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE OverloadedStrings #-}

import           System.Process
import           WildBind
import           WildBind.Input.NumPad
import           WildBind.Seq
import           WildBind.Task.X11
import           WildBind.X11
import           WildBind.X11.Emulate
import           WildBind.X11.KeySym

import           Debug.Trace

main :: IO ()
main = withX11Front $ \x11 -> wildBind (myBinding x11) (makeFrontEnd x11)

pushKey key = spawnCommand ("xdotool key " <> key)

myBinding :: X11Front XKeyEvent -> Binding ActiveWindow XKeyEvent
myBinding x11 = forWebBrowser x11 <> misc x11
  where misc _ = bindsF $ do
          on (ctrl xK_0) `run` liftIO (spawnCommand "ls")

forWebBrowser :: X11Front XKeyEvent -> Binding ActiveWindow XKeyEvent
-- forWebBrowser x11 = do
--   mconcat [remap x11 (ctrl xK_a) xK_Home, remap x11 (ctrl xK_e) xK_End]

forWebBrowser x11 = bindsF $ do
  on (ctrl xK_a) `run` liftIO (spawnCommand "sudo xdotool key Home")
  on (alt xK_w) `as` "Copy" `run` sendKey x11 (ctrl xK_c)
