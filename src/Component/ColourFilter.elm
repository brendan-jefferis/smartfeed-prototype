module Component.ColourFilter (Model, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Common.Alias exposing (Palette, PaletteColour)




--======================================| DUMMY DATA |

dummyOtherPalettes : List Palette
dummyOtherPalettes =
  [ { name = Just "August"
    , colours =
        [ {name = "Ash", hex = "#655643" }
        , { name = "Only Cyan", hex = "#80BCA3" }
        , { name = "Indivisible", hex = "#F6F7BD" }
        , { name = "Golden Apple", hex = "#E6AC27" }
        ]
    }
  , { name = Just "Nordic Sea"
    , colours =
        [ {name = "Baltic", hex = "#448698"}
        , { name = "Pale Blue Eyes", hex = "#90B0C4"}
        , { name = "The Church", hex = "#BFC1BC"}
        , { name = "Soft Feeling", hex = "#FAE5E3"}
        , { name = "Ecorce", hex = "#645B56"}
        ]
    }
  , { name = Just "Forest Shadows"
    , colours =
        [ {name = "Divas Black", hex = "#100C17"}
        , { name = "Whispering Forest", hex = "#658068"}
        , { name = "Putrid", hex = "#D9DDD9"}
        ]
    }
  ]




--======================================| MODEL |

type alias Model =
  { featuredPalette : Palette
  , otherPalettes : List Palette
  , selectedPalette : Palette
  }

init : Palette -> Palette -> Model
init selectedPalette featuredPalette =
  { featuredPalette = featuredPalette
  , otherPalettes = dummyOtherPalettes
  , selectedPalette = selectedPalette
  }




--======================================| UPDATE |

type Action
  = NoOp
  | SelectColour PaletteColour
  | DeselectColor PaletteColour
  | ClearSelectedPalette

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    SelectColour paletteColour ->
      let
        selectedPalette = model.selectedPalette
        updatedPalette =
          if (List.member paletteColour model.selectedPalette.colours) then
            selectedPalette
          else
            { selectedPalette |
                colours = paletteColour :: model.selectedPalette.colours
            }
      in
        { model |
            selectedPalette = updatedPalette
        }

    DeselectColor paletteColour ->
      let
        selectedPalette = model.selectedPalette
        updatedPalette =
          { selectedPalette |
              colours = List.filter (\c -> c /= paletteColour) selectedPalette.colours
          }
      in
        { model |
            selectedPalette = updatedPalette
        }

    ClearSelectedPalette ->
      { model |
          selectedPalette = { name = Nothing, colours = [] }
      }




--======================================| VIEW |

colourCell : Signal.Address Action -> Int -> List PaletteColour -> PaletteColour -> Html
colourCell address count selectedPalette paletteColour =
  let
    cellWidth = (toString (100 / (toFloat count))) ++ "%"
    isSelected = List.member paletteColour selectedPalette
    selectedClass = if isSelected then "selected" else ""
    clickAction = if isSelected then DeselectColor else SelectColour
  in
    div
      [ class ("colour-cell " ++ selectedClass)
      , style
          [ ("background-color", paletteColour.hex)
          , ("width", cellWidth)
          ]
      , title paletteColour.name
      , onClick address (clickAction paletteColour)
      ]
      [ ]

paletteList : Signal.Address Action -> Palette -> Palette -> Html
paletteList address selectedPalette palette =
  let
    paletteCellCount = List.length palette.colours
    title =
      case palette.name of
        Just name ->
          name

        Nothing ->
          ""
  in
    li
      [ ]
      [ h6
          [ class "subheader"]
          [ text title ]
      , ul
          [ class "blank colour-palette" ]
          (List.map (colourCell address paletteCellCount selectedPalette.colours) palette.colours)
      ]

view : Signal.Address Action -> Model -> Html
view address model =
  let
    featuredPaletteCellCount = List.length model.featuredPalette.colours
    selectedPaletteCellCount = List.length model.selectedPalette.colours
  in
    div
      [ class "filter-panel colour-filter" ]
      [ if selectedPaletteCellCount > 0 then
          div
            [ ]
            [ h6
                [ class "subheader" ]
                [ text "Your current palette" ]
            , ul
                [ class "blank colour-palette" ]
                (List.map (colourCell address selectedPaletteCellCount model.selectedPalette.colours) model.selectedPalette.colours)
            , button
                [ class "btn-small secondary"
                , onClick address ClearSelectedPalette ]
                [ text "Clear all" ]
            ]
        else 
          div [] []
      , if featuredPaletteCellCount > 0 then
          div
            [ ]
            [ h6
                [ class "subheader" ]
                [ text "Colours found in this look" ]
            , ul
                [ class "blank colour-palette" ]
                (List.map (colourCell address featuredPaletteCellCount model.selectedPalette.colours) model.featuredPalette.colours)
            , h6
              [ class "subheader with-divider" ]
              [ text "Other palettes" ]
            ]
        else
          div [] []
      , ul
          [ class "blank" ]
          (List.map (paletteList address model.selectedPalette) model.otherPalettes)
      ]