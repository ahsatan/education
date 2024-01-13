module Geometry.Cube
  ( volume,
    area,
  )
where

import Geometry.Cuboid qualified as Cuboid

volume :: Float -> Float
volume s = Cuboid.volume s s s

area :: Float -> Float
area s = Cuboid.area s s s