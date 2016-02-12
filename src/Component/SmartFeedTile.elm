module Component.SmartFeedTile (Model, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

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
  , showDetail : Bool
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
  , showDetail = False
  }


type Action
  = NoOp
  | ToggleFavourite
  | ShowDetail
  | HideDetail

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    ToggleFavourite ->
      let
        isFavourite = not model.isFavourite
      in
        { model |
            isFavourite = isFavourite
        }

    ShowDetail ->
      { model |
          showDetail = True
      }

    HideDetail ->
      { model |
          showDetail = False
      }



--======================================| VIEW |

view : Signal.Address Action -> Model -> Html
view address model =
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
        [ class "photo-container tile-photo"
        , onClick address ShowDetail
        ]
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
                [ class "fa fa-share" ]
                [ ]
            , i
                [ class "fa fa-envelope-o" ]
                [ ]
            , i
                [ class ("fa " ++ if model.isFavourite then "fa-heart" else "fa-heart-o")
                , onClick address ToggleFavourite
                ]
                [ ]
            ]
        ]
    ]