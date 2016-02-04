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
  , tempPalette : Palette
  , filteringComplete : Bool
  }

init : Palette -> Palette -> Model
init selectedPalette featuredPalette =
  { featuredPalette = featuredPalette
  , otherPalettes = dummyOtherPalettes
  , selectedPalette = selectedPalette
  , tempPalette = selectedPalette
  , filteringComplete = False
  }




--======================================| UPDATE |

type Action
  = NoOp
  | SelectColour PaletteColour
  | DeselectColor PaletteColour
  | ClearSelectedPalette
  | SaveAndContinue

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    SelectColour paletteColour ->
      let
        tempPalette = model.tempPalette
        updatedPalette =
          if (List.member paletteColour model.tempPalette.colours) then
            tempPalette
          else
            { tempPalette |
                colours = paletteColour :: model.tempPalette.colours
            }
      in
        { model |
            tempPalette = updatedPalette
        }

    DeselectColor paletteColour ->
      let
        tempPalette = model.tempPalette
        updatedPalette =
          { tempPalette |
              colours = List.filter (\c -> c /= paletteColour) tempPalette.colours
          }
      in
        { model |
            tempPalette = updatedPalette
        }

    ClearSelectedPalette ->
      { model |
          tempPalette = Common.Alias.emptyPalette
      }

    SaveAndContinue ->
      { model |
          selectedPalette = model.tempPalette
        , filteringComplete = True
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
    selectedPaletteCellCount = List.length model.tempPalette.colours
    featuredPaletteCellCount = List.length model.featuredPalette.colours
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
                (List.map (colourCell address selectedPaletteCellCount model.tempPalette.colours) model.tempPalette.colours)
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
      , div
          [ class "content-right" ]
          [ button
              [ onClick address SaveAndContinue ]
              [ text "Save and continue"]
          ]
      ]