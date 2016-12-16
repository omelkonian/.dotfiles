import Yi

import Yi.Style (Color(Default))

import Data.Monoid ((<>))

main = yi $ myConfig

myConfig = defaultVimConfig
  { defaultKm = defaultKm defaultVimConfig
  , configUI  = (configUI defaultVimConfig) { configWindowFill = '~'
                                            , configTheme      = myTheme
                                            }
  }

defaultColor :: Yi.Style.Color
defaultColor = Yi.Style.Default

myTheme = defaultTheme `override` \super _ -> super
  { modelineAttributes   = emptyAttributes { foreground = black,   background = darkcyan }
  , tabBarAttributes     = emptyAttributes { foreground = white,   background = defaultColor }
  , baseAttributes       = emptyAttributes { foreground = defaultColor, background = defaultColor, bold = True }
  , commentStyle         = withFg darkred <> withBd False <> withItlc True
  , selectedStyle        = withReverse True
  , errorStyle           = withBg red   <> withFg white
  , operatorStyle        = withFg brown <> withBd False
  , hintStyle            = withBg brown <> withFg black
  , importStyle          = withFg blue
  , dataConstructorStyle = withFg blue
  , typeStyle            = withFg blue
  , keywordStyle         = withFg yellow
  , builtinStyle         = withFg brown
  , strongHintStyle      = withBg brown <> withUnderline True
  , stringStyle          = withFg brown <> withBd False
  , preprocessorStyle    = withFg blue
  }
