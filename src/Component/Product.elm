module Component.Product (Model) where

type alias Model =
  { title: String
  , description: String
  , price: Float
  , isFavourite: Bool
  , isInCart: Bool
  , photoUrl: String
  , thumbnailUrl: String
  , url: String
  }