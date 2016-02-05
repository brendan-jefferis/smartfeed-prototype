module Component.MaterialFilter (Model, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)

import Common.Alias exposing (Material, MaterialSelector)
import Common.CheckRow as CheckRow

--======================================| DUMMY DATA |

dummyOtherMaterials : List MaterialSelector
dummyOtherMaterials =
  [ { name = "Wood", modifiers = ["", "Light", "Dark", "Rustic"] }
  , { name = "Metal", modifiers = ["", "Painted", "Brushed", "Chrome", "Brass", "Vintage"] }
  , { name = "Fabric", modifiers = ["", "Linen", "Wool", "Cotton", "Synthetic", "Macrosuede"] }
  , { name = "Leather", modifiers = [ "", "Suede", "Artificial", "Full-grain", "Nubick", "Patent", "Deerskin", "Top-grain", "Reptile/marine" ] }
  ]

--======================================| MODEL |

type alias Model =
  { selectedMaterials : List Material
  , featuredMaterials : List Material
  , otherMaterials : List Material
  , tempMaterials : List Material
  }

init : List Material -> Model
init featuredMaterials =
  { selectedMaterials = []
  , featuredMaterials = featuredMaterials
  , otherMaterials = []
  , tempMaterials = []
  }




--======================================| UPDATE |

type Action = NoOp

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model




--======================================| VIEW |

listItem : Material -> Html
listItem material =
  let
    label =
      case material.modifier of
        Just val ->
          val ++ " " ++ material.name

        Nothing ->
          material.name 
  in
    CheckRow.view label False

view : Signal.Address Action -> Model -> Html
view address model =
  let
    featuredMaterialsCount = List.length model.featuredMaterials
  in
    div
      [ class "filter-panel material-filter" ]
      [ if featuredMaterialsCount > 0 then
          div
            [ ]
            [ h6
                [ class "subheader" ]
                [ text "Materials featured in these products" ]
            , ul
                [ class "blank materials" ]
                (List.map listItem model.featuredMaterials)
            , h6
              [ class "subheader with-divider" ]
              [ text "Other materials" ]
            ]
        else
          div [] []
      ]