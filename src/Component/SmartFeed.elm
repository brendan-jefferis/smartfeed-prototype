module Component.SmartFeed (Model, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Component.SmartFeedTile as Tile
import Component.SmartFeedTileDetail as TileDetail
import Component.Product as Product




--======================================| DUMMY DATA |

dummyProductsOne : List Product.Model
dummyProductsOne =
  [ { title = "Dahlia sofa"
    , description = "This is the first product"
    , price = 12.99
    , isFavourite = False
    , isInCart = False
    , photoUrl = "/images/product/dahlia-sofa.png"
    , thumbnailUrl = "/images/thumbnail/dahlia-sofa.png"
    , url = "/products/1"
    }
  , { title = "Product 2"
    , description = "This is the second product"
    , price = 120.99
    , isFavourite = False
    , isInCart = False
    , photoUrl = "/images/product/brass-lamp.png"
    , thumbnailUrl = "/images/thumbnail/brass-lamp.png"
    , url = "/products/2"
    }
  , { title = "Product 3"
    , description = "This is the third product"
    , price = 1200.99
    , isFavourite = False
    , isInCart = False
    , photoUrl = "/images/product/fern.png"
    , thumbnailUrl = "/images/thumbnail/fern.png"
    , url = "/products/3"
    }
  , { title = "Product 3"
    , description = "This is the third product"
    , price = 88.99
    , isFavourite = False
    , isInCart = False
    , photoUrl = "/images/product/ceiling-light.png"
    , thumbnailUrl = "/images/thumbnail/ceiling-light.png"
    , url = "/products/4"
    }
  ]

dummyProductsTwo : List Product.Model
dummyProductsTwo =
  [ { title = "Product 4"
    , description = "This is the fourth product"
    , price = 8.99
    , isFavourite = False
    , isInCart = False
    , photoUrl = "/images/product/leather-sofa.png"
    , thumbnailUrl = "/images/thumbnail/leather-sofa.png"
    , url = "/products/5"
    }
  , { title = "Product 5"
    , description = "This is the fifth product"
    , price = 88.99
    , isFavourite = False
    , isInCart = False
    , photoUrl = "/images/product/drum-table.png"
    , thumbnailUrl = "/images/thumbnail/drum-table.png"
    , url = "/products/6"
    }
  , { title = "Mariner Floor Lamp"
    , description = "Stylish floor lamp with nautical theme."
    , price = 8800.50
    , isFavourite = False
    , isInCart = False
    , photoUrl = "/images/product/nautical-lamp.png"
    , thumbnailUrl = "/images/thumbnail/nautical-lamp.png"
    , url = "/products/7"
    }
  ]

dummyTiles : List Tile.Model
dummyTiles =
  [ { tileId = 1
    , brand = "Freedom Furniture"
    , logoUrl = "/images/logo/freedom-logo.png"
    , title = "Nordic inspired"
    , photoUrl = "/images/tile/nordic-room.png"
    , isFavourite = False
    , url = "/tile/1"
    , products = dummyProductsOne
    }
  , { tileId = 2
    , brand = "Freedom Furniture"
    , logoUrl = "/images/logo/freedom-logo.png"
    , title = "Signature Collection"
    , photoUrl = "/images/tile/signature-collection.png"
    , isFavourite = False
    , url = "/tile/2"
    , products = dummyProductsTwo
    }
  ]

--======================================| MODEL |

type alias Model =
  { tiles: List Tile.Model
  , isTileDetailView: Bool
  , tileDetail: TileDetail.Model
  }

init : Model
init =
  { tiles = dummyTiles
  , isTileDetailView = False
  , tileDetail = TileDetail.init []
  }




--======================================| UPDATE |

type Action
  = NoOp
  | TileDetail TileDetail.Action
  | ShowTileDetail Tile.Model
  | HideTileDetail

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    TileDetail act ->
      { model |
          tileDetail = TileDetail.update act model.tileDetail
      }

    ShowTileDetail tile ->
      let
        tileDetail = TileDetail.init tile.products
      in
        { model |
            isTileDetailView = True
          , tileDetail = tileDetail
        }

    HideTileDetail ->
      { model |
          isTileDetailView = False
        , tileDetail = TileDetail.init []
      }





--======================================| VIEW |

tileList: Signal.Address Action -> Tile.Model -> Html
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
    [  div
        [ class "scrollable-list" ]
        [ ul
            [ class "tile-list" ]
            (List.map (tileList address) model.tiles)
        ]
    , if model.isTileDetailView then
        div
          [ class "tile-detail" ]
          [ div
              [ class "nav-bar" ]
              [ button
                [ class "btn-light"
                , onClick address HideTileDetail ]
                [ text "Back to feed" ]
              ]
          , TileDetail.view (Signal.forwardTo address TileDetail) model.tileDetail
          ]
      else
        div [] []
    ]




--======================================| SIGNALS |

actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp


model : Signal Model
model =
  Signal.foldp update init actions.signal
