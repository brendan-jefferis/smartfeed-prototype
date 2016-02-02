module Component.SmartFeedTileDetail where

import Html exposing (..)
import Html.Attributes exposing (..)

import Component.Product as Product



--======================================| MODEL |

type alias Model =
  { products: List Product.Model
  }

init : List Product.Model -> Model
init products =
  { products = products
  }




--======================================| UPDATE |

type Action = NoOp

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model




--======================================| VIEW |

productView : Signal.Address Action -> Product.Model -> Html
productView address product =
  li
    [ class "product-list-item" ]
    [ div
        [ class "thumbnail-container" ]
        [ img
            [ class "thumbnail"
            , src product.thumbnailUrl
            ]
            [ ]
        ]
    , div
        [ class "title-container" ]
        [ p
            [ class "title" ]
            [ text product.title ]
        , p
            [ class "price" ]
            [ text ("$" ++ (toString product.price))]
        ]
    , div
        [ class "actions-container" ]
        [ i
            [ class "fa fa-heart-o" ]
            [ ]
        , i
            [ class "fa fa-cart-plus" ]
            [ ]
        , i
            [ class "fa fa-info-circle" ]
            [ ]
        ]
    ]

filterView : Signal.Address Action -> Model -> Html
filterView address model =
  div
    [ class "filter-container" ]
    [ span
        [ class "filter-title" ]
        [ text "Show me more like this..."]
    , div
        [ class "action-row" ]
        [ button
            [ ]
            [ text "Colour" ]
        , button
            [ ]
            [ text "Materials" ]
        , button
            [ ]
            [ text "Product" ]
        , button
            [ ]
            [ text "Style" ]
        ]
    ]

view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ class "tile-detail-contents" ]
    [ ul
      [ class "product-list" ]
      (List.map (productView address) model.products)
    , (filterView address model)
    ]




--======================================| SIGNALS |

actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp

model : List Product.Model -> Signal Model
model products =
  Signal.foldp update (init products) actions.signal