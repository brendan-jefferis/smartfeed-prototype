module Component.StyleFilter (Model, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Common.CheckRow as CheckRow




--======================================| DUMMY DATA |

dummyStyles : List String
dummyStyles = 
  [ "Traditional", "Japanese/Zen", "Transitional", "Art", "Nautical/Coastal", "Industrial modern", "Scandinavian", "Vintage", "Mid-century modern", "Contemporary" ]

--======================================| MODEL |

type alias Model =
  { featuredStyles : List String
  , selectedStyles : List String
  , otherStyles : List String
  , filteringComplete : Bool
  }


init : List String -> List String -> Model
init selectedStyles featuredStyles =
  { featuredStyles = featuredStyles
  , selectedStyles = selectedStyles
  , otherStyles = dummyStyles
  , filteringComplete = False
  }




--======================================| UPDATE |

type Action
  = NoOp
  | SelectStyle String
  | DeselectStyle String
  | Clear

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    SelectStyle style ->
      let
        updatedStyles =
          if (List.member style model.selectedStyles) then
            model.selectedStyles
          else
            style :: model.selectedStyles
      in
        { model |
            selectedStyles = updatedStyles
        }

    DeselectStyle style ->
      { model |
          selectedStyles = List.filter (\c -> c /= style) model.selectedStyles
      }

    Clear ->
      { model |
          selectedStyles = []
      }




--======================================| VIEW |

listItem : Signal.Address Action -> List String -> String -> Html
listItem address selectedStyles style =
  let
    checked = List.member style selectedStyles
    clickAction = if checked then DeselectStyle else SelectStyle
  in
    li
      [ onClick address (clickAction style) ]
      [ CheckRow.view style checked ]

view : Signal.Address Action -> Model -> Html
view address model =
  let
    selectedStylesCount = List.length model.selectedStyles
    featuredStylesCount = List.length model.featuredStyles
  in
    div
      [ class "filter-panel product-filter" ]
      [ if selectedStylesCount > 0 then
          div
            [ ]
            [ h6
                [ class "subheader" ]
                [ text "Your current styles" ]
            , ul
                [ class "blank products" ]
                (List.map (listItem address model.selectedStyles) model.selectedStyles)
            , button
                [ class "btn-small secondary"
                , onClick address Clear
                ]
                [ text "Clear all" ]
            ]
        else 
          div [] []
      , if featuredStylesCount > 0 then
        div
          [ ]
          [ h6
              [ class "subheader" ]
              [ text "Styles featured in these products" ]
          , ul
              [ class "blank" ]
              (List.map (listItem address model.selectedStyles) model.featuredStyles)
          , h6
            [ class "subheader with-divider" ]
            [ text "Other styles" ]
          ]
        else
          div [] []
      , ul
          [ class "blank" ]
          (List.map (listItem address model.selectedStyles) model.otherStyles)
      ]