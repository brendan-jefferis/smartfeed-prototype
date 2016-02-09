module Component.ActiveFilterPanel (Model, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Common.Tag as Tag
import Common.Alias exposing (Filter)


type alias Model =
  { filter : Common.Alias.Filter
  , isFilterPanelVisible : Bool
  }

init : Filter -> Model
init filter =
  { filter = filter
  , isFilterPanelVisible = False
  }

type Action
  = NoOp
  | ShowFilterPanel
  | HideFilterPanel

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    ShowFilterPanel ->
      { model |
          isFilterPanelVisible = True
      }

    HideFilterPanel ->
      { model |
          isFilterPanelVisible = False
      }      






filterListItem : Signal.Address Action -> String -> Html
filterListItem address label =
  li
    [ ]
    [ Tag.view label
    ]

filterGroup : Signal.Address Action -> String -> List String -> Html
filterGroup address label filter =
  div
    [ ]
    [ h4
        [ class "subheader" ]
        [ text label ]
    , ul
        [ class "blank" ]
        (List.map (filterListItem address) filter)
    ]

view : Signal.Address Action -> Model -> Html
view address model =
  let
    colourCount = List.length model.filter.colour.colours
    materialCount = List.length model.filter.material
    productCount = List.length model.filter.category
    styleCount = List.length model.filter.style
  in
    div
      [ class "active-filter" ]
      [ if (isFiltered model.filter) then
          div
            [ class "active-filter-bar" ]
            [ span
                [ class "status-indicator" ]
                [ text "Showing tailored results" ]
            , if model.isFilterPanelVisible then
                button
                  [ class "btn-small secondary"
                  , onClick address HideFilterPanel
                  ]
                  [ text "Cancel" ]
              else
                button
                  [ class "btn-small secondary"
                  , onClick address ShowFilterPanel
                  ]
                  [ text "Edit" ]
            , if model.isFilterPanelVisible then
                div
                  [ class "filter-panel" ]
                  [ if colourCount > 0 then
                      (filterGroup address "Colour" (List.map .name model.filter.colour.colours))
                    else
                      div [] []
                  , if materialCount > 0 then
                      (filterGroup address "Material" (List.map .name model.filter.material))
                    else
                      div [] []
                  , if productCount > 0 then
                      (filterGroup address "Product" model.filter.category)
                    else
                      div [] []
                  , if styleCount > 0 then
                      (filterGroup address "Style" model.filter.style)
                    else
                      div [] []
                  ]
              else
                div [] []
            ]
        else 
          div [] []
    ]


--======================================| HELPERS |

isFiltered : Common.Alias.Filter -> Bool
isFiltered filter =
  not (List.isEmpty filter.colour.colours) ||
  not (List.isEmpty filter.material) ||
  not (List.isEmpty filter.category) ||
  not (List.isEmpty filter.style)