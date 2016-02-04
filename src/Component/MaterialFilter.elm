module Component.MaterialFilter (Model, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)




--======================================| MODEL |

type alias Material =
  { name : String
  , isSelected : Bool
  }

type alias Model =
  { materials : List Material
  }

init : Model
init =
  { materials = []
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
    [ class "filter-panel material-filter" ]
    [ text "material" ]