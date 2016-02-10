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
  | RemoveCategoryFilter String
  | RemoveStyleFilter String
  | Done

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

    RemoveCategoryFilter category ->
      let
        filter = model.filter
        updatedFilter =
          { filter |
              category = List.filter (\c -> c /= category) model.filter.category
          }
      in
        { model |
            filter = updatedFilter
        }

    RemoveStyleFilter style ->
      let
        filter = model.filter
        updatedFilter =
          { filter |
              style = List.filter (\c -> c /= style) model.filter.style
          }
      in
        { model |
            filter = updatedFilter
        }

    Done ->
      { model |
          isFilteringComplete = True
        , isFilterPanelVisible = False
      }




colourFilterListItem : Signal.Address Action -> PaletteColour -> Html
colourFilterListItem address colour =
  li
    [ onClick address (RemoveColourFilter colour) ]
    [ Tag.viewWithSwatch colour.hex colour.name
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

categoryFilterListItem : Signal.Address Action -> String -> Html
categoryFilterListItem address category =
  li
    [ onClick address (RemoveCategoryFilter category)]
    [ Tag.view category
    ]

categoryFilterGroup : Signal.Address Action -> List String -> Html
categoryFilterGroup address filter =
  div
    [ ]
    [ h4
        [ class "subheader" ]
        [ text "Category" ]
    , ul
        [ class "blank" ]
        (List.map (categoryFilterListItem address) filter)
    ]

styleFilterListItem : Signal.Address Action -> String -> Html
styleFilterListItem address style =
  li
    [ onClick address (RemoveStyleFilter style)]
    [ Tag.view style
    ]

styleFilterGroup : Signal.Address Action -> List String -> Html
styleFilterGroup address filter =
  div
    [ ]
    [ h4
        [ class "subheader" ]
        [ text "Style" ]
    , ul
        [ class "blank" ]
        (List.map (styleFilterListItem address) filter)
    ]

materialFilterListItem : Signal.Address Action -> String -> Html
materialFilterListItem address material =
  li
    [ ]
    [ Tag.view material
    ]

materialFilterGroup : Signal.Address Action -> List String -> Html
materialFilterGroup address filter =
  div
    [ ]
    [ h4
        [ class "subheader" ]
        [ text "Material" ]
    , ul
        [ class "blank" ]
        (List.map (materialFilterListItem address) filter)
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
                [ class "toggle-panel secondary"
                , onClick address HideFilterPanel
                ]
                [ text (if isFiltered model.filter then "Hide" else "Cancel") ]
            else
              button
                [ class "toggle-panel secondary"
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
                    (materialFilterGroup address (List.map .name model.filter.material))
                  else
                    div [] []
                , if productCount > 0 then
                    (categoryFilterGroup address model.filter.category)
                  else
                    div [] []
                , if styleCount > 0 then
                    (styleFilterGroup address model.filter.style)
                  else
                    div [] []
                , div
                    [ class "content-right" ]
                    [ button
                        [ class "secondary"
                        , onClick address Done
                        ]
                        [ text "Done" ]
                    ]
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
    colourFilter = if not (List.isEmpty filter.colour.colours) then "colour" else ""
    materialFilter = if not (List.isEmpty filter.material) then "material" else ""
    categoryFilter = if not (List.isEmpty filter.category) then "category" else ""
    styleFilter = if not (List.isEmpty filter.style) then "style" else ""
    filters = List.filter (\s -> s /= "") [colourFilter, materialFilter, categoryFilter, styleFilter]
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