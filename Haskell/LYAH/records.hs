-- Records automatically generate accessors of the field names
-- Creating records: can add fields in different order from how declared in data type

data Person = Person
  { firstName :: String, -- auto-generated accessor: firstName :: Person -> String
    lastName :: String,
    age :: Int,
    height :: Float,
    phone :: String
  }
  deriving (Show)

p :: Person
p = Person {firstName = "Galilea", lastName = "Light", age = 27, height = 67.0, phone = "5559874321"}