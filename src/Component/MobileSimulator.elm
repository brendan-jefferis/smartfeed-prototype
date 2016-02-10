module Component.MobileSimulator (Model, init, Action, update, view)where

import Html exposing (..)
import Html.Attributes exposing (..)

import Component.SmartFeed as SmartFeed




--======================================| MODEL |

type alias Model =
  { smartFeed : SmartFeed.Model
  , isDeviceMobile : Bool
  }

init : Bool -> Model
init isDeviceMobile =
  { smartFeed = SmartFeed.init
  , isDeviceMobile = isDeviceMobile
  }




--======================================| UPDATE |

type Action
  = NoOp
  | SmartFeed SmartFeed.Action

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    SmartFeed act ->
      { model |
          smartFeed = SmartFeed.update act model.smartFeed
      }




--======================================| VIEW |

mockDeviceNav : Html
mockDeviceNav =
  div
    [ class "mock-device-nav" ]
    [ i
        [ class "fa fa-battery-full" ]
        [ ]
    , span
        [ class "nav-text" ]
        [ text "1:20" ]
    ]

view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ ]
    [ if model.isDeviceMobile then
        SmartFeed.view (Signal.forwardTo address SmartFeed) model.smartFeed
      else
        div
          [ ]
          [ h4
              [ ]
              [ text "SmartFeed Prototype"]
          , p
              [ class "subheader" ]
              [ text "Revision 1" ]
          , div
              [ class "mobile-sim-container ratio-16-9" ]
              [ mockDeviceNav
              , SmartFeed.view (Signal.forwardTo address SmartFeed) model.smartFeed
              ]
          ]
    ]




--======================================| SIGNALS |

actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp

model : Bool -> Signal Model
model isDeviceMobile =
  Signal.foldp update (init isDeviceMobile) actions.signal