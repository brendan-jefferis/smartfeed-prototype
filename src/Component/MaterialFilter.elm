module Component.MaterialFilter (Model, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String

import Common.Alias exposing (Material, MaterialSelector)
import Common.CheckRow as CheckRow

--======================================| DUMMY DATA |

dummyMaterials : List Material
dummyMaterials =
  [ { name = "Wood", modifier = Just ""}
  , { name = "Metal", modifier = Just "" }
  , { name = "Fabric", modifier = Just "" }
  , { name = "Leather", modifier = Just ""}
  ]

--======================================| MODEL |

type alias Model =
  { selectedMaterials : List Material
  , featuredMaterials : List Material
  , otherMaterials : List Material
  , filteringComplete : Bool
  }

init : List Material -> List Material -> Model
init selectedMaterials featuredMaterials =
  { selectedMaterials = selectedMaterials
  , featuredMaterials = featuredMaterials
  , otherMaterials = dummyMaterials
  , filteringComplete = False
  }




--======================================| UPDATE |

type Action
  = NoOp
  | SelectMaterial Material
  | DeselectMaterial Material
  | Clear

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    SelectMaterial material ->
      let
        updatedMaterials =
          if (List.member material model.selectedMaterials) then
            model.selectedMaterials
          else
            material  :: model.selectedMaterials
      in
        { model |
            selectedMaterials = updatedMaterials
        }

    DeselectMaterial material ->
      { model |
          selectedMaterials = List.filter (\c -> c /= material) model.selectedMaterials
      }

    Clear ->
      { model |
          selectedMaterials = []
      }



--======================================| VIEW |

listItem : Signal.Address Action -> List Material -> Material -> Html
listItem address selectedMaterials material =
  let
    label =
      case material.modifier of
        Just val ->
          val ++ " " ++ (String.toLower material.name)

        Nothing ->
          material.name

    checked = List.member material selectedMaterials
    clickAction = if checked then DeselectMaterial else SelectMaterial
  in
    li
      [ onClick address (clickAction material) ]
      [ CheckRow.view label checked ]

view : Signal.Address Action -> Model -> Html
view address model =
  let
    selectedMaterialsCount = List.length model.selectedMaterials
    featuredMaterialsCount = List.length model.featuredMaterials
  in
    div
      [ class "filter-panel material-filter" ]
      [ if selectedMaterialsCount > 0 then
          div
            [ ]
            [ h6
                [ class "subheader" ]
                [ text "Your current materials" ]
            , ul
                [ class "blank materials" ]
                (List.map (listItem address model.selectedMaterials) model.selectedMaterials)
            , button
                [ class "btn-small secondary"
                , onClick address Clear
                ]
                [ text "Clear all" ]
            ]
        else 
          div [] []
      , if featuredMaterialsCount > 0 then
          div
            [ ]
            [ h6
                [ class "subheader" ]
                [ text "Materials found in these products" ]
            , ul
                [ class "blank materials" ]
                (List.map (listItem address model.selectedMaterials) model.featuredMaterials)
            , h6
              [ class "subheader with-divider" ]
              [ text "Other materials" ]
            ]
        else
          div [] []
      , ul
          [ class "blank" ]
          (List.map (listItem address model.selectedMaterials) model.otherMaterials)
      ]