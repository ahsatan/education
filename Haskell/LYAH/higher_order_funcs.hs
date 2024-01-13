compareWith100 :: (Real n) => n -> Ordering
compareWith100 = compare 100 -- no need to declare param (to compare against 100), result is already func that takes a param

-- Partial Application of Infix Operators: surround with parens and include param on either side!
-- "Section" is wrapping of infix operator: (op) (exp op) (op exp)
half :: (Floating n) => n -> n
half = (/ 2)

isUppercase :: Char -> Bool
isUppercase = (`elem` ['A' .. 'Z']) -- can also do with `` (infix) versions of two-param functions

sub1 :: (Num n) => n -> n
sub1 = subtract 1 -- because (- 1) would equal the negative of 1, the subtract func is necessary here

-- Pass functions to functions like any other param
applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)

ha :: String
ha = applyTwice (++ "HA") "HOO" -- "HOOHAHA"

a :: (Num n) => [n]
a = applyTwice (3 :) [1] -- cons is an infix operator, of course ;)

zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' _ [] _ = []
zipWith' _ _ [] = []
zipWith' f (x : xs) (y : ys) = f x y : zipWith' f xs ys

maxs :: [Int]
maxs = zipWith' max [6, 3, 2, 1] [7, 3, 1, 5]

flip' :: (a -> b -> c) -> b -> a -> c
flip' f x y = f y x

-- can use map and filter as alternative to list comprehension, depends what's easier to read
map' :: (a -> b) -> [a] -> [b]
map' _ [] = []
map' f (x : xs) = f x : map' f xs

b :: [Int]
b = map (+ 1) [0, 1, 2, 3] -- [1, 2, 3, 4]

filter' :: (a -> Bool) -> [a] -> [a]
filter' _ [] = []
filter' f (x : xs)
  | f x = x : tail
  | otherwise = tail
  where
    tail = filter' f xs

c :: [Int]
c = filter' (> 0) [-2, -1, 0, 1, 2] -- [1, 2]

qsort' :: (Ord a) => [a] -> [a]
qsort' [] = []
qsort' (x : xs) = lt ++ [x] ++ gt
  where
    lt = qsort' (filter' (<= x) xs)
    gt = qsort' (filter' (> x) xs)

l :: Int
l = head (filter (\x -> x `mod` 3829 == 0) [100000, 99999 ..]) -- lambda predicate

-- takeWhile: take from front of list as long as predicate holds true, end at first false
s :: Int
s = sum (takeWhile (< 10000) (filter odd (map (^ 2) [1 ..])))

s' :: Int
s' = sum (takeWhile (< 10000) [n' | n <- [1 ..], let n' = n ^ 2, odd n']) -- list comprehension version

-- collatz numbers
chain :: (Integral n) => n -> [n]
chain 1 = [1]
chain n
  | odd n = n : chain (n * 3 + 1)
  | even n = n : chain (n `div` 2)

numLongChains :: Int
numLongChains = length (filter (> 15) (map (length . chain) [1 .. 100]))

-- higher order all the things
mults :: (Integral n) => [n -> n]
mults = map (*) [0 ..]

-- foldl takes func with args 'acc next', foldr takes func with args 'next acc' (each has acc on fold-from side)
sumPlusOne :: (Num n) => [n] -> n
sumPlusOne = foldl (+) 1

elem' :: (Eq a) => a -> [a] -> Bool
elem' x = foldl (\acc y -> x == y || acc) False

mapTwice :: (a -> b) -> [a] -> [b]
mapTwice f = foldr (\x acc -> f x : f x : acc) []

reverse' :: [a] -> [a]
reverse' = foldl (flip (:)) []

-- foldl1 and foldr1 take the first element in the list as the base accumulator value (error if called on empty lists)
head' :: [a] -> a
head' = foldl1 const -- const always evaluates to first of two params

last' :: [a] -> a
last' = foldr1 (\_ x -> x)

-- scanl/scanr: like foldl/foldr but create an array of all stepwise accs including base case
-- scanl1/scanr1: same as above but starting with first/last element not base case
s1 :: [Int]
s1 = scanl (+) 0 [1, 2, 3, 4] -- [0, 1, 3, 6, 10]

s2 :: [Int]
s2 = scanl1 (+) [1, 2, 3, 4] -- [1, 3, 6, 10]

-- Q: how many elements does it take for the sum of the roots of all natural numbers to exceed 1000?
sqrtSums :: Int
sqrtSums = length (takeWhile (<= 1000) (scanl1 (+) (map sqrt [1 ..]))) + 1

-- function application w/ $: lowest precedence, right associative, can eliminate need for parens
-- ($) :: (a -> b) -> a -> b
s3 :: Float
s3 = sqrt $ 2 + 3 + 4 -- sqrt (2 + 3 + 4) instead of (sqrt 2) + 3 + 4

sqrtSums' :: Int
sqrtSums' = 1 + length (takeWhile (<= 1000) $ scanl1 (+) $ map sqrt [1 ..])

-- tricky: $ is a function so can use in higher order funcs
-- ($ 1) is infix: passes 1 as param
mapFuncs :: [Float]
mapFuncs = map ($ 1) [(1 +), (3 *), (^ 2), sqrt] -- [2.0, 3.0, 1.0, 1.0], float due to sqrt, partial application fills in param from function application where needed

-- function composition: f . g x = f (g x) - can pass composed functions as one arg
-- (.) :: (b -> c) -> (a -> b) -> a -> c
ns :: [Int]
ns = map (negate . (+ 1) . abs) [-2, -1, 0, 1, 2] -- [-3, -2, -1, -2, -3]

-- function composition with partial application and function application
m :: Float
m = sum . replicate 5 . max 6.7 $ 8.9

-- points-free style: use function composition to avoid including args (the 'point' is the value being acted on not literal '.'s)
silly :: (RealFrac a, Floating a, Integral b) => a -> b
silly x = ceiling (negate (tan (cos (max 50 x)))) -- can't get rid of x because it's wrapped in parens

silly' :: (RealFrac a, Floating a, Integral b) => a -> b
silly' = ceiling . negate . tan . cos . max 50 -- no value x, thus points-free

-- balance function composition with legibility, may be worth using let/where statements to name sub-expressions instead of a long chain