-- "nullary": data type value constructors that have no fields

-- see Shapes.hs for including data types in a module, using them here like any other module

import Shapes (Shape, baseCircle, nudge)

c :: Shape
c = baseCircle 3

c' :: Shape
c' = nudge c 4 2

-- data types can have type parameters!  e.g. list, Map, Maybe
--   can have type constraints in data declarations but it's convention not to - would have to always declare constraint in funcs using that data
-- reinvent Maybe:
data Maybe' a = None | Some a
  deriving (Show)

m1 :: Maybe' String
m1 = Some "Hello"

infixr 5 ::: -- fixity declaration: how tightly bound (relative to other infix) as well as R or L-associative (e.g. * is infixl 7 and + is infixl 6)

data List' a = Empty | a ::: (List' a) -- recursive data structures a-ok! funcs with only special characters are automatic infix operators without ``
  deriving (Eq, Ord, Show, Read)

data Vector a = Vector a a a
  deriving (Show)

vMult :: (Num n) => Vector n -> n -> Vector n
(Vector x y z) `vMult` n = Vector (x * n) (y * n) (z * n)

-- reinvent Either: Left typically holds fail state info (beyond Maybe's None which would only indicate failure not why) and Right holds results
data Either' a b = Left a | Right b
  deriving (Eq, Ord, Show, Read)

-- automagic typeclass deriving: Eq, Ord, Enum, Bounded, Show, Read
--   Eq: check value constructors are same then == each field so long as each field type implements Eq!
--   Show: convert value constructor name and fields to one String so long as all fields implement Show
--   Read: convert String to correct value constructor, may have to annotate with type (read "..." :: TypeName) if can't infer,
--     must fill in generic types (e.g. read "Just 't'" :: Maybe Char)
--   Ord: within a type earlier value constructor declarations are LT later ones, then compare fields (in order?) that must each implement Ord
--   Enum: data types with only nullary value constructors can be enumerated in order declared
--   Bounded: data types with only nullary value constructors are bounded by first and last value constructor declared!

-- type synonyms: type SynonymName = Type (e.g. type String = [Char])
--   can use to provide type information more clearly
--   can be parametrized (e.g. type AssocList k v = [(k, v)])
--   can do partial application! e.g. type IntMap = Map Int (implies type IntMap v = Map Int v)
type PhoneNumber = String

type Name = String

type PhoneBook = [(Name, PhoneNumber)]