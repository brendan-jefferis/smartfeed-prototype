module Common.Tag (..) where

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

viewWithSwatch : String -> String -> Html
viewWithSwatch hex label =
  div
    [ class "tag with-swatch" ]
    [ div
        [ class "tag-swatch"
        , style [("background", hex)]
        ]
        [ ]
    , span
        [ ]
        [ text label ]
    , i
        [ class "close fa fa-times-circle" ]
        [ ]
    ]