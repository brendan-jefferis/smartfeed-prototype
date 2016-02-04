module Component.StyleFilter (Model, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)




--======================================| MODEL |

type alias Style =
  { name : String
  , isSelected : Bool
  }

type alias Model =
  { styles : List Style
  }


init : Model
init =
  { styles = []
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
    [ class "filter-panel style-filter" ]
    [ text "style..." ]