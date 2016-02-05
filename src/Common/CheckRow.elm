module Common.CheckRow (view) where

import Html exposing (..)
import Html.Attributes exposing (..)

view : String -> Bool -> Html
view label checked =
  div
    [ class "check-row clickable" ]
    [ span
        [ ]
        [ text label ]
    , i
        [ class (if checked then "fa fa-check-square-o" else "fa fa-square-o") ]
        [ ]
    ]