module Geometry.Cuboid
  ( volume,
    area,
  )
where

volume :: Float -> Float -> Float -> Float
volume x y z = rectangleArea x y * z

area :: Float -> Float -> Float -> Float
area x y z = 2 * (rectangleArea x y + rectangleArea x z + rectangleArea y z)

rectangleArea :: Float -> Float -> Float
rectangleArea = (*)