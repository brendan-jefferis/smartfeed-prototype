-- SmartFeed data models

type alias Product =
  { title: String
  , description: String
  , price: Float
  , isFavourite: Bool
  , isInCart: Bool
  , url: String
  , features: Maybe List String
  , colors: Maybe List String
  , materials: Maybe List String
  , types: Maybe List String
  , styles: Maybe List String
  , variants: Maybe List Product
  }

type alias SmartFeedTileDetail =
  { products: List Product
  , currentFilter: Maybe SmartFeedFilter
  , filter: Maybe SmartFeedFilter
  , foundColors: Maybe List String
  , foundMaterials: Maybe List String
  , foundTypes: Maybe List String
  , foundStyles: Maybe List String
  , otherColors: Maybe List String
  , otherMaterials: Maybe List String
  , otherTypes: Maybe List String
  , otherStyles: Maybe List String
  }

type alias SmartFeedTile =
  { title: String
  , logoUrl: String
  , caption: String
  , imageUrl: String
  , isFavourite: Bool
  , url: String
  , products: List Product
  }



type alias BooleanOperator = And | Or

type alias AttributeWithModifers =
  { selectedTag: String
  , tagList: List String
  , selectedModifier: String
  , modifierList: List String
  }

type alias AttributeFilter =
  { booleanOperator: BooleanOperator
  , tags: Maybe List String
  }

type alias AttributeFilterWithModifiers =
  { booleanOperator: BooleanOperator
  , tags: Maybe List AttributeWithModifers
  }

type alias SmartFeedFilter =
  { colors: AttributeFilter
  , materials: AttributeFilterWithModifiers
  , types: AttributeFilter
  , styles: AttributeFilter
  }

type alias SmartFeed =
  { tiles: List SmartFeedTile
  , filter: Maybe SmartFeedFilter
  }