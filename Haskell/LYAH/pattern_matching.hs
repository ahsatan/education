-- pattern matching: define rules on subsequent lines, will match from top down
lucky :: (Integral a) => a -> String
lucky 7 = "Hooray!  Lucky 7!"
lucky _ = "Bad luck this time..."

sayMe :: (Integral a) => a -> String
sayMe 1 = "One!"
sayMe 2 = "Two!"
sayMe 3 = "Three!"
sayMe _ = "Not between 1 and 3."

factorial :: (Integral t) => t -> t -- t > 0
factorial 0 = 1
factorial n = n * factorial (n - 1)

-- quick sort
qsort :: (Ord a) => [a] -> [a]
qsort [] = []
qsort (x : xs) = qsort lt ++ [x] ++ qsort gt
  where
    -- 'where' provides local bindings for the (pattern-matched) function, indenting is important
    lt = [y | y <- xs, y <= x]
    gt = [y | y <- xs, y > x]

addPts :: (Num a) => (a, a) -> (a, a) -> (a, a)
addPts (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)

third :: (a, b, c) -> c
third (_, _, z) = z

prs :: [(Integer, Integer)]
prs = [(1, 3), (4, 3), (2, 4), (5, 3), (5, 6), (3, 1)]

sums :: [Integer]
sums = [a + b | (a, b) <- prs]

head' :: [a] -> a
head' [] = error "attempted to behead an empty list"
head' (x : _) = x

len :: (Num b) => [a] -> b
len [] = 0
len (_ : xs) = 1 + len xs

-- use 'as patterns' to represent entire following pattern: name@(pattern)
fstC :: String -> String
fstC [] = "empty!"
fstC s@(c : cs) = "first letter of " ++ s ++ " is " ++ [c]

-- Guards: match boolean conditions instead of patterns
sillyMult :: (Real a) => a -> a -> a
sillyMult x y
  | x > y = y * y
  | x == y = y ^ 3
sillyMult x y = x * y -- falls through to here if no guard catches

sillyMult' :: (Real a) => a -> a -> a
sillyMult' x y
  | x' > y = y * gtExpn
  | x' == y = y ^ eqExpn
  | otherwise = x * y -- 'otherwise' is catch all at end of guard
  where
    -- 'where' applies for entire guard expression
    x' = x + 1
    (gtExpn, eqExpn) = (2, 3) -- can label constants for ease of understanding, can use pattern matching

toDensities :: (Fractional a) => [(a, a)] -> [a]
toDensities xs = [density m v | (m, v) <- xs]
  where
    density m v = m / v -- can of course have local funcs

-- 'let' (expression) is similar to 'where' (syntax element) but only applies to subsequent 'in'
cyl :: (Floating a) => a -> a -> a
cyl r h =
  let sideArea = 2 * pi * r * h
      topArea = pi * r ^ 2
   in sideArea + 2 * topArea

x :: [(Int, Int, Int)]
x = [let square x = x ^ 2 in (square 5, square 3, square 2)] -- [(25, 9, 4)]

y :: Int
y = let a = 100; b = 200; c = 300 in a * b * c -- 6000000, separate let bindings with ';' when inline

z :: Int
z = (let (a, b, c) = (1, 2, 3) in a * b * c) * 100 -- 600, let is good for quick pattern matching components

-- let binds the name in a list comprehension instead of filtering, can assign expression to var not just data
-- can then filter on let bindings after
toDensities' :: (Ord a, Fractional a) => [(a, a)] -> [a]
toDensities' xs = [density | (m, v) <- xs, let density = m / v, density < 1.2]

-- function definition pattern matching is syntactic sugar for case
qsort' :: (Ord a) => [a] -> [a]
qsort' xs =
  case xs of
    [] -> []
    x : xs' ->
      let lt = [x' | x' <- xs', x' <= x]
          gt = [x' | x' <- xs', x' > x]
       in qsort' lt ++ [x] ++ qsort' gt

describe :: [a] -> String
describe xs =
  "List is " ++ case xs of
    [] -> "empty."
    [x] -> "a singleton."
    _ -> "a long list."

describe' :: [a] -> String
describe' xs = "List is " ++ what xs
  where
    what [] = "empty."
    what [x] = "a singleton."
    what _ = "a long list."