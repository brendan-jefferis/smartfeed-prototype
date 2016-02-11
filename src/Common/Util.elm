module Common.Util (..) where

import String

import Common.Alias exposing (Material)


materialToString : Material -> String
materialToString material =
  case material.modifier of
    Just mod ->
      mod ++ " " ++ (String.toLower material.name)

    Nothing ->
      material.name