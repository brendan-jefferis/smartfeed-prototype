module Common.Alias (..) where

type alias Filter =
  { colour : Palette
  , material : List Material
  , category : List String
  , style : List String
  }

emptyFilter : Filter
emptyFilter =
  { colour = emptyPalette
  , material = emptyMaterials
  , category = []
  , style = []
  }

type alias PaletteColour =
  { name : String
  , hex : String
  }

type alias Palette =
  { name : Maybe String
  , colours : List PaletteColour
  }

emptyPalette : Palette
emptyPalette =
  { name = Nothing, colours = [] }

type alias Product =
  { title : String
  , description : String
  , price : Float
  , isFavourite : Bool
  , isInCart : Bool
  , photoUrl : String
  , thumbnailUrl : String
  , url : String
  , category : String
  }

type alias Material =
  { name : String
  , modifier : Maybe String
  }

type alias MaterialSelector =
  { name : String
  , modifiers : List String
  }

emptyMaterials : List Material
emptyMaterials =
  [ { name = "", modifier = Nothing } ]