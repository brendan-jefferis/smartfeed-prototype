module Component.ProductFilter (Model, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)




--======================================| MODEL |

type alias Model =
  { products: List String
  , selectedProduct: String
  }

init : Model
init =
  { products = []
  , selectedProduct = ""
  }




--======================================| UPDATE |

type Action = NoOp

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model




--======================================| VIEW |

view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ class "filter-panel product-filter" ]
    [ text "product..." ]