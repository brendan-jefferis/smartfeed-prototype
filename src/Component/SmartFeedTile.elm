module Component.SmartFeedTile (Model, init, view) where

import Html exposing (..)
import Html.Attributes exposing (..)

import Common.Alias exposing (Palette, Material, Product)



--======================================| MODEL |

type alias Model =
  { tileId : Int
  , brand : String
  , logoUrl : String
  , title : String
  , photoUrl : String
  , isFavourite : Bool
  , url : String
  , products : List Product
  , palette : Palette
  , materials : List Material
  , styles : List String
  }

init : Model
init =
  { tileId = 0
  , brand = ""
  , logoUrl = ""
  , title = ""
  , photoUrl = ""
  , isFavourite = False
  , url = ""
  , products = []
  , palette = Common.Alias.emptyPalette
  , materials = Common.Alias.emptyMaterials
  , styles = []
  }




--======================================| VIEW |

view : Model -> Html
view model =
  div
    [ class "tile-contents" ]
    [ div
        [ class "header-row" ]
        [ div
            [ class "logo-container" ]
            [ img
                [ class "logo"
                , src model.logoUrl
                ]
                [ ]
            ]
        , span
            [ class "brand-name" ]
            [ text model.brand ]
        ]
    , div
        [ class "photo-container tile-photo" ]
        [ img
            [ class "tile-photo"
            , src model.photoUrl
            ]
            []
        ]
    , div
        [ class "footer-row" ]
        [ span
            [ class "tile-title" ]
            [ text model.title ]
        , div
            [ class "actions" ]
            [ i
                [ class "fa fa-ellipsis-h" ]
                [ ]
            , i
                [ class "fa fa-envelope-o" ]
                [ ]
            , i
                [ class "fa fa-heart-o" ]
                [ ]
            ]
        ]
    ]