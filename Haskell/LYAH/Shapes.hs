-- Data Type declarations: data TypeName = ConstructorName1 Type1 ... TypeN | ... | ConstructorNameN Type1 ... TypeN
--   value constructors are functions that take the given types (can pattern match) and return TypeName

module Shapes
  ( Point (..), -- (..) exports all value constructors, could also export only a selection: TypeName (ConstructorName1, ..., ConstructorNameN)
    Shape (..), -- If exclude value constructors (no parens after TypeName), could only make Shapes with exposed funcs, e.g. baseCircle, and can't pattern match
    surface,
    nudge,
    baseCircle,
    baseRectangle,
  )
where

data Point = Point Float Float -- constructor CAN have same name as type, common for single constructor types
  deriving (Show)

data Shape = Circle Point Float | Rectangle Point Point
  deriving (Show) -- magic (because it knows all the subtypes?)

surface :: Shape -> Float
surface (Circle _ r) = pi * r ^ 2
surface (Rectangle (Point x1 y1) (Point x2 y2)) = abs $ (x2 - x1) * (y2 - y1)

nudge :: Shape -> Float -> Float -> Shape
nudge s dx dy = case s of
  (Circle c r) -> Circle (nudgePoint c) r
  (Rectangle p1 p2) -> Rectangle (nudgePoint p1) (nudgePoint p2)
  where
    nudgePoint (Point x y) = Point (x + dx) (y + dy)

baseCircle :: Float -> Shape
baseCircle = Circle (Point 0 0)

baseRectangle :: Float -> Float -> Shape
baseRectangle w h = Rectangle (Point 0 0) (Point w h)