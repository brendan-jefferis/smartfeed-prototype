module Common.CheckRow (view) where

import Html exposing (..)
import Html.Attributes exposing (..)

view : String -> Bool -> Html
view label checked =
  div
    [ class "check-row" ]
    [ span
        [ ]
        [ text label ]
    , span
        [ ]
        [ text (toString checked)]
    ]