module Common.Tag (view) where

import Html exposing (..)
import Html.Attributes exposing (..)

view : String -> Html
view label =
  div
    [ class "tag" ]
    [ span
        [ ]
        [ text label ]
    , i
        [ class "close fa fa-times-circle" ]
        [ ]
    ]
