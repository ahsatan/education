-- Records automatically generate accessors of the field names
-- Creating records: can add fields in different order from how declared in data type

data Person = Person
  { firstName :: String, -- auto-generated accessor: firstName :: Person -> String
    lastName :: String,
    age :: Int,
    height :: Float,
    phone :: String
  }
  deriving (Eq, Show)

-- Can define records with declared fields in any order
p :: Person
p = Person {firstName = "Galilea", lastName = "Light", phone = "5559874321", age = 27, height = 67.0}

-- Can define records like standard value constructors but must list fields in order
-- Generally better to use record syntax to clarify what each piece of data means
p2 :: Person
p2 = Person "Andrea" "Alanthea" 18 60.5 "5551234567"

data Car = Car {company :: String, model :: String, year :: Int}
  deriving (Show)

-- Can partial match records without needing to leave _s for irrelevant fields
makeAndModel :: Car -> String
makeAndModel Car {company = c, model = m} = c ++ " " ++ m