module Component.SmartFeedTileDetail (Model, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Component.ColourFilter as ColourFilter
import Component.MaterialFilter as MaterialFilter
import Component.ProductFilter as ProductFilter
import Component.StyleFilter as StyleFilter
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
  }

init : List Product -> Palette -> Palette -> Model
init products selectedPalette featuredPalette =
  { products = products
  , palette = featuredPalette
  , visibleFilter = None
  , colourFilter = ColourFilter.init selectedPalette featuredPalette -- pass down colour palette here
  , materialFilter = MaterialFilter.init
  , productFilter = ProductFilter.init
  , styleFilter = StyleFilter.init
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
      { model |
          colourFilter = ColourFilter.update act model.colourFilter
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




--======================================| SIGNALS |

actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp

model : List Product -> Palette -> Palette -> Signal Model
model products selectedPalette featuredPalette =
  Signal.foldp update (init products selectedPalette featuredPalette) actions.signal