module Component.SmartFeedTileDetail (Model, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Component.ColourFilter as ColourFilter
import Component.MaterialFilter as MaterialFilter
import Component.ProductFilter as ProductFilter
import Component.StyleFilter as StyleFilter
import Component.SmartFeedTile as Tile
import Common.Alias exposing (Product, Palette)



--======================================| MODEL |

type Filter
  = None
  | Colour
  | Material
  | Product
  | Style

type alias Model =
  { products : List Product
  , palette : Palette
  , visibleFilter : Filter
  , colourFilter : ColourFilter.Model
  , materialFilter : MaterialFilter.Model
  , productFilter : ProductFilter.Model
  , styleFilter : StyleFilter.Model
  , filteringComplete : Bool
  }

init : Tile.Model -> Palette -> Model
init tile selectedPalette =
  { products = tile.products
  , palette = tile.palette
  , visibleFilter = None
  , colourFilter = ColourFilter.init selectedPalette tile.palette
  , materialFilter = MaterialFilter.init
  , productFilter = ProductFilter.init
  , styleFilter = StyleFilter.init
  , filteringComplete = False
  }




--======================================| UPDATE |

type Action
  = NoOp
  | ColourFilterActions ColourFilter.Action
  | MaterialFilterActions MaterialFilter.Action
  | ProductFilterActions ProductFilter.Action
  | StyleFilterActions StyleFilter.Action
  | ShowColourFilter
  | ShowMaterialFilter
  | ShowProductFilter
  | ShowStyleFilter

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    ColourFilterActions act ->
      let
        colourFilter = ColourFilter.update act model.colourFilter
        complete = colourFilter.filteringComplete
      in
        { model |
            colourFilter = colourFilter
          , filteringComplete = complete
        }

    MaterialFilterActions act ->
      { model |
          materialFilter = MaterialFilter.update act model.materialFilter
      }

    ProductFilterActions act ->
      { model |
          productFilter = ProductFilter.update act model.productFilter
      }

    StyleFilterActions act ->
      { model |
          styleFilter = StyleFilter.update act model.styleFilter
      }

    ShowColourFilter ->
      { model |
          visibleFilter = Colour
      }

    ShowMaterialFilter ->
      { model |
          visibleFilter = Material
        }

    ShowProductFilter ->
      { model |
          visibleFilter = Product
      }

    ShowStyleFilter ->
      { model |
          visibleFilter = Style
      }




--======================================| VIEW |

productView : Signal.Address Action -> Product -> Html
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

styleFilterView : Signal.Address Action -> Model -> Html
styleFilterView address model =
  div [] [ text "style" ]

filterView : Signal.Address Action -> Model -> Html
filterView address model =
  let
    currentFilter = case model.visibleFilter of
      None ->
        div [] []

      Colour ->
        ColourFilter.view (Signal.forwardTo address ColourFilterActions) model.colourFilter

      Material ->
        MaterialFilter.view (Signal.forwardTo address MaterialFilterActions) model.materialFilter

      Product ->
        ProductFilter.view (Signal.forwardTo address ProductFilterActions) model.productFilter

      Style ->
        StyleFilter.view (Signal.forwardTo address StyleFilterActions) model.styleFilter
  in
    div
      [ class "filter-container" ]
      [ span
          [ class "filter-title" ]
          [ text "Show me more like this..."]
      , div
          [ class "action-row" ]
          [ button
              [ onClick address ShowColourFilter ]
              [ text "Colour" ]
          , button
              [ onClick address ShowMaterialFilter ]
              [ text "Material" ]
          , button
              [ onClick address ShowProductFilter]
              [ text "Product" ]
          , button
              [ onClick address ShowStyleFilter ]
              [ text "Style" ]
          ]
      , currentFilter
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



{-
--======================================| SIGNALS |

actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp

model : List Product -> Palette -> Palette -> Signal Model
model tile selectedPalette =
  Signal.foldp update (init products selectedPalette featuredPalette) actions.signal
-}