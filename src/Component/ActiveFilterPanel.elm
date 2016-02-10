module Component.ActiveFilterPanel (Model, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import String

import Common.Tag as Tag
import Common.Alias exposing (Filter, PaletteColour)


type alias Model =
  { filter : Common.Alias.Filter
  , isFilterPanelVisible : Bool
  , isFilteringComplete : Bool
  }

init : Filter -> Model
init filter =
  { filter = filter
  , isFilterPanelVisible = False
  , isFilteringComplete = False
  }

type Action
  = NoOp
  | ShowFilterPanel
  | HideFilterPanel
  | RemoveColourFilter Common.Alias.PaletteColour

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

    RemoveColourFilter paletteColour ->
      let
        filter = model.filter
        selectedPalette = model.filter.colour
        updatedPalette =
          { selectedPalette |
              colours = List.filter (\c -> c /= paletteColour) selectedPalette.colours
          }
        updatedFilter =
          { filter |
              colour = updatedPalette
          }
      in
        { model |
            filter = updatedFilter
        }




colourFilterListItem : Signal.Address Action -> PaletteColour -> Html
colourFilterListItem address colour =
  li
    [ onClick address (RemoveColourFilter colour) ]
    [ Tag.viewWithSwatch colour.hex colour.name
    ]

filterListItem : Signal.Address Action -> String -> Html
filterListItem address label =
  li
    [ ]
    [ Tag.view label
    ]

colourFilterGroup : Signal.Address Action -> List PaletteColour -> Html
colourFilterGroup address filter =
  div
    [ ]
    [ h4
        [ class "subheader" ]
        [ text "Colour" ]
    , ul
        [ class "blank" ]
        (List.map (colourFilterListItem address) filter)
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

searchBar : Signal.Address Action -> Model -> Html
searchBar address model =
  div
    [ class "search-bar" ]
    [ input
        [ type' "text" 
        , placeholder "Search for products, colours, styles etc"
        ]
        [ ]
    , i
        [ class "fa fa-search search-icon" ]
        [ ]
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
      [ div
          [ class "active-filter-bar" ]
          [ span
              [ class "status-indicator" ]
              [ text (statusIndicatorText model.filter) ]
          , if model.isFilterPanelVisible then
              button
                [ class "btn-small secondary"
                , onClick address HideFilterPanel
                ]
                [ text (if isFiltered model.filter then "Hide" else "Cancel") ]
            else
              button
                [ class "btn-small secondary"
                , onClick address ShowFilterPanel
                ]
                [ text (if isFiltered model.filter then "Show" else "Search") ]
          , if model.isFilterPanelVisible then
              div
                [ class "filter-panel" ]
                [ h4
                    [ class "subheader" ]
                    [ text "Keyword" ]
                , (searchBar address model)
                , if colourCount > 0 then
                    (colourFilterGroup address model.filter.colour.colours)
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
    ]


--======================================| HELPERS |

statusIndicatorText : Common.Alias.Filter -> String
statusIndicatorText filter =
  if (isFiltered filter) then
    "Filtering by " ++ (activeFilterText filter)
  else
    "Showing all products"

activeFilterText : Common.Alias.Filter -> String
activeFilterText filter =
  let
    filters = ["colour", "material", "style", "keyword", "category"]
    filterTest =
      if List.length filters > 3 then
        (String.join ", " (List.take 3 filters)) ++ " & more"
      else
        String.join ", " filters
  in
    filterTest

isFiltered : Common.Alias.Filter -> Bool
isFiltered filter =
  not (List.isEmpty filter.colour.colours) ||
  not (List.isEmpty filter.material) ||
  not (List.isEmpty filter.category) ||
  not (List.isEmpty filter.style)