module Component.CategoryFilter (Model, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Common.CheckRow as CheckRow




--======================================| DUMMY DATA |

dummyCategories : List String
dummyCategories = 
  [ "Tables", "Chairs", "Rugs", "Art" ]


--======================================| MODEL |

type alias Model =
  { featuredCategories : List String
  , selectedCategories : List String
  , otherCategories : List String
  , filteringComplete : Bool
  }

init : List String -> List String -> Model
init selectedCategories featuredCategories =
  { featuredCategories = featuredCategories
  , selectedCategories = selectedCategories
  , otherCategories = dummyCategories
  , filteringComplete = False
  }




--======================================| UPDATE |

type Action
  = NoOp
  | SelectCategory String
  | DeselectCategory String
  | Clear

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    SelectCategory category ->
      let
        updatedCategories =
          if (List.member category model.selectedCategories) then
            model.selectedCategories
          else
            category  :: model.selectedCategories
      in
        { model |
            selectedCategories = updatedCategories
        }

    DeselectCategory category ->
      { model |
          selectedCategories = List.filter (\c -> c /= category) model.selectedCategories
      }

    Clear ->
      { model |
          selectedCategories = []
      }




--======================================| VIEW |

listItem : Signal.Address Action -> List String -> String -> Html
listItem address selectedCategories category =
  let
    checked = List.member category selectedCategories
    clickAction = if checked then DeselectCategory else SelectCategory
  in
    li
      [ onClick address (clickAction category) ]
      [ CheckRow.view category checked ]

view : Signal.Address Action -> Model -> Html
view address model =
  let
    selectedCategoriesCount = List.length model.selectedCategories
    featuredCategoriesCount = List.length model.featuredCategories
  in
    div
      [ class "filter-panel product-filter" ]
      [ if selectedCategoriesCount > 0 then
          div
            [ ]
            [ h6
                [ class "subheader" ]
                [ text "Your current products" ]
            , ul
                [ class "blank products" ]
                (List.map (listItem address model.selectedCategories) model.selectedCategories)
            , button
                [ class "btn-small secondary"
                , onClick address Clear
                ]
                [ text "Clear all" ]
            ]
        else 
          div [] []
      , if featuredCategoriesCount > 0 then
        div
          [ ]
          [ h6
              [ class "subheader" ]
              [ text "Categories of these products" ]
          , ul
              [ class "blank" ]
              (List.map (listItem address model.selectedCategories) model.featuredCategories)
          , h6
            [ class "subheader with-divider" ]
            [ text "Other categories" ]
          ]
        else
          div [] []
      , ul
          [ class "blank" ]
          (List.map (listItem address model.selectedCategories) model.otherCategories)
      ]