module Component.SmartFeed (Model, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Component.ActiveFilterPanel as ActiveFilterPanel
import Component.SmartFeedTile as Tile
import Component.SmartFeedTileDetail as TileDetail
import Common.Alias exposing (Product, Palette, emptyPalette)
import Common.Util as Util



--======================================| DUMMY DATA |

dummyProductsOne : List Product
dummyProductsOne =
  [ { title = "Dahlia sofa"
    , description = "This is the first product"
    , price = 12.99
    , isFavourite = False
    , isInCart = False
    , photoUrl = "/images/product/dahlia-sofa.png"
    , thumbnailUrl = "/images/thumbnail/dahlia-sofa.png"
    , url = "/products/1"
    , category = "Sofas"
    }
  , { title = "Product 2"
    , description = "This is the second product"
    , price = 120.99
    , isFavourite = False
    , isInCart = False
    , photoUrl = "/images/product/brass-lamp.png"
    , thumbnailUrl = "/images/thumbnail/brass-lamp.png"
    , url = "/products/2"
    , category = "Lamps"
    }
  , { title = "Product 3"
    , description = "This is the third product"
    , price = 1200.99
    , isFavourite = False
    , isInCart = False
    , photoUrl = "/images/product/fern.png"
    , thumbnailUrl = "/images/thumbnail/fern.png"
    , url = "/products/3"
    , category = "Indoor plants"
    }
  , { title = "Product 3"
    , description = "This is the third product"
    , price = 88.99
    , isFavourite = False
    , isInCart = False
    , photoUrl = "/images/product/ceiling-light.png"
    , thumbnailUrl = "/images/thumbnail/ceiling-light.png"
    , url = "/products/4"
    , category = "Ceiling lights"
    }
  ]

dummyProductsTwo : List Product
dummyProductsTwo =
  [ { title = "Product 4"
    , description = "This is the fourth product"
    , price = 8.99
    , isFavourite = False
    , isInCart = False
    , photoUrl = "/images/product/leather-sofa.png"
    , thumbnailUrl = "/images/thumbnail/leather-sofa.png"
    , url = "/products/5"
    , category = "Sofas"
    }
  , { title = "Product 5"
    , description = "This is the fifth product"
    , price = 88.99
    , isFavourite = False
    , isInCart = False
    , photoUrl = "/images/product/drum-table.png"
    , thumbnailUrl = "/images/thumbnail/drum-table.png"
    , url = "/products/6"
    , category = "Coffee tables"
    }
  , { title = "Mariner Floor Lamp"
    , description = "Stylish floor lamp with nautical theme."
    , price = 8800.50
    , isFavourite = False
    , isInCart = False
    , photoUrl = "/images/product/nautical-lamp.png"
    , thumbnailUrl = "/images/thumbnail/nautical-lamp.png"
    , url = "/products/7"
    , category = "Lamps"
    }
  ]

dummyTiles : List Tile.Model
dummyTiles =
  [ { tileId = 3
    , brand = "Freedom Furniture"
    , logoUrl = "/images/logo/freedom-logo.png"
    , title = "Dahlia sofa"
    , photoUrl = "/images/product/dahlia-sofa.png"
    , isFavourite = False
    , url = "/tile/3"
    , products =
      [{ title = "Dahlia sofa"
      , description = "This is the first product"
      , price = 12.99
      , isFavourite = False
      , isInCart = False
      , photoUrl = "/images/product/dahlia-sofa.png"
      , thumbnailUrl = "/images/thumbnail/dahlia-sofa.png"
      , url = "/products/1"
      , category = "Sofas"
      }]
    , palette = { name = Nothing, colours = [{ name = "Grey", hex = "#D3D0CB" }, { name = "Fawn", hex = "#AC9C82" }] }
    , materials = [{name = "Fabric", modifier = Just "Cotton" }, {name = "Metal", modifier = Just "Brass"}, {name = "Wood", modifier = Just "Light"}]
    , styles = ["Scandinavian"]
    }
  , { tileId = 1
    , brand = "Freedom Furniture"
    , logoUrl = "/images/logo/freedom-logo.png"
    , title = "Nordic inspired"
    , photoUrl = "/images/tile/nordic-room.png"
    , isFavourite = False
    , url = "/tile/1"
    , products = dummyProductsOne
    , palette = { name = Nothing, colours = [ { name = "Black", hex = "#1A1611" }, { name = "Grey", hex = "#D3D0CB" }, { name = "Burlap", hex = "#ABA49A" }, { name = "White", hex = "#FFFFFF" }, { name = "Brown", hex = "#543822" }, { name = "Fawn", hex = "#AC9C82" }] }
    , materials = [{name = "Fabric", modifier = Just "Cotton" }, {name = "Metal", modifier = Just "Brass"}, {name = "Wood", modifier = Just "Light"}]
    , styles = ["Scandinavian", "Bohemian"]
    }
  , { tileId = 2
    , brand = "Freedom Furniture"
    , logoUrl = "/images/logo/freedom-logo.png"
    , title = "Signature Collection"
    , photoUrl = "/images/tile/signature-collection.png"
    , isFavourite = False
    , url = "/tile/2"
    , products = dummyProductsTwo
    , palette = { name = Nothing, colours = [{ name = "Midnight", hex = "#211F20"}, {name = "Slate", hex = "#47464B"}, {name = "Light Cyan", hex = "#7ED3D0"}, {name = "Brick", hex = "#CA3727"}, {name = "Lemon tree", hex = "#E3CD2A"}] }
    , materials = [{name = "Leather", modifier = Nothing}, {name = "Metal", modifier = Just "Brushed"}, {name = "Fabric", modifier = Just "Linen"}, {name = "Wood", modifier = Nothing}]
    , styles = ["Contemporary", "Industrial modern", "Vintage"]
    }
  ]

--======================================| MODEL |

type alias Model =
  { tiles : List Tile.Model
  , isTileDetailView : Bool
  , tileDetail : TileDetail.Model
  , activeFilterPanel : ActiveFilterPanel.Model 
  , filter : Common.Alias.Filter
  }

init : Model
init =
  { tiles = dummyTiles
  , isTileDetailView = False
  , tileDetail = TileDetail.init Tile.init Common.Alias.emptyFilter
  , activeFilterPanel = ActiveFilterPanel.init Common.Alias.emptyFilter
  , filter = Common.Alias.emptyFilter
  }




--======================================| UPDATE |

type Action
  = NoOp
  | TileDetail TileDetail.Action
  | ShowTileDetail Tile.Model
  | HideTileDetail
  | ActiveFilterPanelActions ActiveFilterPanel.Action

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    TileDetail act ->
      let
        tileDetail = TileDetail.update act model.tileDetail
        filter = model.filter
        updatedFilter =
          { filter |
              colour = tileDetail.colourFilter.selectedPalette
            , material = tileDetail.materialFilter.selectedMaterials
            , category = tileDetail.productFilter.selectedCategories
            , style = tileDetail.styleFilter.selectedStyles
          }
        showTileDetail = tileDetail.filteringComplete /= True
      in
        { model |
            tileDetail = tileDetail
          , filter = if tileDetail.filteringComplete then updatedFilter else model.filter
          , activeFilterPanel = ActiveFilterPanel.init (if tileDetail.filteringComplete then updatedFilter else model.filter)
          , isTileDetailView = showTileDetail
        }

    ShowTileDetail tile ->
      let
        tileDetail = TileDetail.init tile model.filter
      in
        { model |
            isTileDetailView = True
          , tileDetail = tileDetail
        }

    HideTileDetail ->
      { model |
          isTileDetailView = False
        , tileDetail = TileDetail.init Tile.init Common.Alias.emptyFilter
      }

    ActiveFilterPanelActions act ->
      let
        activeFilterPanel = ActiveFilterPanel.update act model.activeFilterPanel
      in
        { model |
            activeFilterPanel = activeFilterPanel
          , filter = if activeFilterPanel.isFilteringComplete then activeFilterPanel.filter else model.filter
        }


--======================================| VIEW |

tileList : Signal.Address Action -> Tile.Model -> Html
tileList address tile =
  li
    [ class "tile"
    , onClick address (ShowTileDetail tile)
    ]
    [ Tile.view tile ]

view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ class "smart-feed" ] 
    [ ActiveFilterPanel.view (Signal.forwardTo address ActiveFilterPanelActions) model.activeFilterPanel
    , if model.isTileDetailView then
        div
          [ class "tile-detail" ]
          [ div
              [ class "nav-bar" ]
              [ button
                [ class "btn-light"
                , onClick address HideTileDetail ]
                [ text "Back" ]
              ]
          , TileDetail.view (Signal.forwardTo address TileDetail) model.tileDetail
          ]
      else
        div
        [ class "scrollable-list" ]
        [ ul
            [ class "tile-list" ]
            (List.map (tileList address) model.tiles)
        ]
    , p
      [ id "debug" ]
      [ text (logFilter model.filter)]
    ]

logFilter : Common.Alias.Filter -> String
logFilter filter =
  "Colour: " ++ (toString filter.colour.colours) ++ ", Material: " ++ (toString (List.map Util.materialToString filter.material)) ++ ", Category: " ++ (toString filter.category) ++ ", Style: " ++ (toString filter.style)

