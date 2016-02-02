module Main where

import Html exposing (Html)
import StartApp.Simple exposing (start)

import Component.MobileSimulator exposing (init, update, view)




--======================================| ENTRY POINT |

main : Signal Html
main =
  start
    { model = init
    , update = update
    , view = view
    }
