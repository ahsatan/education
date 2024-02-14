-- "nullary": data type value constructors that have no fields

-- see Shapes.hs for including data types in a module, using them here like any other module

import Data.Map qualified as Map
import Shapes (Point (Point), Shape (Circle), baseCircle, nudge)

c :: Shape
c = baseCircle 3

c' :: Shape
c' = nudge c 4 2

-- Constructors are just functinos and can be partially applied!
cs :: [Shape]
cs = map (Circle (Point 0 0)) [1, 2, 3, 4]

{- data types can have type parameters!  e.g. list, Map, Maybe
    can add type constraints in data declarations but convention is to NEVER DO SO
    - would have to always declare constraint in funcs using that data,
      instead just require the type constraints in functions where it matters
-}
data Maybe' a = None | Some a
  deriving (Show)

m1 :: Maybe' String
m1 = Some "Hello"

infixr 5 ::: -- fixity declaration: how tightly bound (relative to other infix) as well as R or L-associative (e.g. * is infixl 7 and + is infixl 6)

data List' a = Empty | a ::: (List' a) -- recursive data structures a-ok! funcs with only special characters are automatic infix operators without ``
  deriving (Eq, Ord, Show, Read)

infixr 5 +++

(+++) :: List' a -> List' a -> List' a
Empty +++ ys = ys
(x ::: xs) +++ ys = x ::: (xs +++ ys)

data Vector a = Vector a a a
  deriving (Show)

vMult :: (Num n) => Vector n -> n -> Vector n
(Vector x y z) `vMult` n = Vector (x * n) (y * n) (z * n)

-- reinvent Either: Left typically holds fail state info (beyond Maybe's None which would only indicate failure not why) and Right holds results
data Either' a b = Left' a | Right' b
  deriving (Eq, Ord, Show, Read)

{- automagic typeclass deriving: Eq, Ord, Enum, Bounded, Show, Read
   Eq: check value constructors are same then == each field so long as each field type implements Eq!
   Show: convert value constructor name and fields to one String so long as all fields implement Show
   Read: convert String to correct value constructor, may have to annotate with type (read "..." :: TypeName) if can't infer,
     must fill in generic types (e.g. read "Just 't'" :: Maybe Char)
   Ord: within a type earlier value constructor declarations are LT later ones, then compare fields (in order?) that must each implement Ord
   Enum: data types with only nullary value constructors can be enumerated in order declared
   Bounded: data types with only nullary value constructors are bounded by first and last value constructor declared!
-}
data Day = Sunday | Monday | Tuesday | Wednesday | Thursday | Friday | Saturday
  deriving (Eq, Ord, Show, Read, Bounded, Enum)

weekdays :: [Day]
weekdays = [Monday .. Friday] -- [Monday, Tuesday, Wednesday, Thursday, Friday]

days :: [Day]
days = [minBound .. maxBound] :: [Day] -- [Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday]

{- type synonyms: type SynonymName = Type (e.g. type String = [Char])
     can use to provide type information more clearly
     can be parametrized
     can do partial application! e.g. type IntMap = Map Int (implies type IntMap v = Map Int v)
-}
type PhoneNumber = String

type Name = String

type PhoneBook = [(Name, PhoneNumber)]

type AssocList k v = [(k, v)]

lookup' :: (Eq k) => k -> AssocList k v -> Maybe' v
lookup' _ [] = None
lookup' k ((k', v) : xs)
  | k == k' = Some v
  | otherwise = lookup' k xs

data LockerState = Taken | Free
  deriving (Show, Eq)

type Code = String

type LockerMap = Map.Map Int (LockerState, Code)

assignLocker :: Int -> LockerMap -> Either' String Code
assignLocker n ls =
  case Map.lookup n ls of
    Nothing -> Left' $ "Locker #" ++ show n ++ " doesn't exist."
    Just (ls, c) ->
      if ls == Free
        then Right' c
        else Left' $ "Locker #" ++ show n ++ " is already taken."

data BTree a = EmptyTree | Node a (BTree a) (BTree a)
  deriving (Show, Read, Eq)

singleton :: a -> BTree a
singleton x = Node x EmptyTree EmptyTree

treeInsert :: (Ord a) => a -> BTree a -> BTree a
treeInsert x EmptyTree = singleton x
treeInsert x t@(Node v l r)
  | x < v = Node v (treeInsert x l) r
  | x > v = Node v l (treeInsert x r)
  | otherwise = t

treeElem :: (Ord a) => a -> BTree a -> Bool
treeElem x EmptyTree = False
treeElem x (Node v l r)
  | x == v = True
  | x < v = treeElem x l
  | x > v = treeElem x r

listToTree :: (Ord a) => [a] -> BTree a
listToTree = foldr treeInsert EmptyTree

-- typeclass definition
class Eq' a where
  (===) :: a -> a -> Bool
  (/==) :: a -> a -> Bool
  x === y = not (x /== y)
  x /== y = not (x === y)

{- can constrain (effectively subclass) typeclasses
class (Eq' a) => Num' a where
  ...
-}

-- custom define typeclass implementations
data TrafficLight = Red | Yellow | Green

instance Eq TrafficLight where
  (==) :: TrafficLight -> TrafficLight -> Bool
  Red == Red = True
  Yellow == Yellow = True
  Green == Green = True
  _ == _ = False

instance Show TrafficLight where
  show :: TrafficLight -> String
  show Red = "Stop"
  show Yellow = "Slow Down"
  show Green = "Go"

-- typeclass instances (so far)) are defined on concrete types
-- a is constrained to be Eq type so can use x == y below
instance (Eq a) => Eq (Maybe' a) where
  (==) :: Maybe' a -> Maybe' a -> Bool
  Some x == Some y = x == y
  None == None = True
  _ == _ = False

-- practice
class Truthy a where
  truthy :: a -> Bool

instance Truthy Int where
  truthy :: Int -> Bool
  truthy 0 = False
  truthy _ = True

instance Truthy [a] where
  truthy :: [a] -> Bool
  truthy [] = False
  truthy _ = True

instance Truthy Bool where
  truthy :: Bool -> Bool
  truthy = id

instance Truthy (Maybe a) where
  truthy :: Maybe a -> Bool
  truthy Nothing = False
  truthy _ = True

instance Truthy (BTree a) where
  truthy :: BTree a -> Bool
  truthy EmptyTree = False
  truthy _ = True

instance Truthy TrafficLight where
  truthy :: TrafficLight -> Bool
  truthy Red = False
  truthy _ = True

truthyIf :: (Truthy a) => a -> b -> b -> b
truthyIf pred yes no = if truthy pred then yes else no

-- now we get crazy
-- here, f is a type constructor and NOT a concrete type
-- works with container-like types but not enums like TrafficLight
class Functor' f where
  fmap' :: (a -> b) -> f a -> f b

instance Functor' [] where
  fmap' :: (a -> b) -> [a] -> [b]
  fmap' = map

instance Functor' Maybe where
  fmap' :: (a -> b) -> Maybe a -> Maybe b
  fmap' f (Just a) = Just (f a)
  fmap' _ Nothing = Nothing

instance Functor' BTree where
  fmap' :: (a -> b) -> BTree a -> BTree b
  fmap' _ EmptyTree = EmptyTree
  fmap' f (Node v l r) = Node (f v) (fmap' f l) (fmap' f r)

instance Functor' (Either' e) where
  fmap' :: (a -> b) -> Either' e a -> Either' e b
  fmap' _ (Left' e) = Left' e
  fmap' f (Right' a) = Right' (f a)

instance Functor' (Map.Map k) where
  fmap' :: (v -> v') -> Map.Map k v -> Map.Map k v' -- ' is ok in type var names
  fmap' = Map.map