-- load in ghci: :l filename
-- refresh after changes in ghci: :r

double :: (Num a) => a -> a
double x = x + x

double2 :: (Num a) => a -> a -> a
double2 x y = double x + double y

doubleSmall :: (Real a) => a -> a
doubleSmall x = if x < 100 then double x else x

-- ' usually means non-lazy (strict) evaluation, here it means 'slightly modified'
doubleSmall' :: (Real a) => a -> a
doubleSmall' x = doubleSmall x + 1

-- function w/o params is effectively a static definition
-- Strings are syntactic sugar for lists of chars
s :: String
s = "Some string!" -- "Some string!"

-- list elements must be homogenous (all same type)
-- lists are syntactic sugar for e1 : ... : en : []
l1 :: [Int]
l1 = [1, 2, 3, 4, 5] -- [1, 2, 3, 4, 5]

l2 :: [Char]
l2 = ['h', 'e', 'l', 'l', 'o'] -- "hello"

-- ++ is concat -> copies elements of both to new list
l3 :: [Int]
l3 = l1 ++ l1 -- [1, 2, 3, 4, 5, 1, 2, 3, 4, 5]

l4 :: String
l4 = l2 ++ s -- "helloSome string!"

-- : is cons -> prepends to list (has ref to remainder, no need to copy)
l5 :: [Int]
l5 = 0 : l1 -- [0, 1, 2, 3, 4, 5]

l6 :: String
l6 = 's' : l2 -- "shello"

-- 0-based index access into list with !! (can get OOB errors)
e :: Int
e = l5 !! 2 -- 2

c :: Char
c = l6 !! 1 -- 'h'

-- list comparisons are in lexicographical order (L -> R)
res1 :: Bool
res1 = [3, 2, 1] > [2, 10, 100] -- True

res2 :: Bool
res2 = [3, 2, 1] > [4, 3] -- False

res3 :: Bool
res3 = [3, 2, 1] == [3, 2, 1, 0] -- False

-- list functions: head, tail, last (inverse of head), init (inverse of tail),
--                 length, null (like empty?), reverse, take, drop, maximum, minimum,
--                 sum (list of numbers), product (list of numbers), elem (i.e. contains)
l :: Int
l = last l1 -- 5

i :: [Int]
i = init l1 -- [1, 2, 3, 4]

n1 :: Bool
n1 = null l1 -- False

t1 :: [Int]
t1 = take 3 l1 -- [1, 2, 3], take 0 -> [], take num > length -> entire list

t2 :: [Int]
t2 = drop 3 l1 -- [4, 5], drop 0 -> entire list, drop num > length -> []

-- convert prefix to infix for two-param function: `funcName`
res4 :: Bool
res4 = 3 `elem` l1 -- True

-- ranges: can set step interval with first 2 elements
r1 :: [Int]
r1 = [1 .. 20] -- [1, 2, ..., 19, 20]

r2 :: [Char]
r2 = ['b' .. 'q'] -- ['b', 'c', ... 'p', 'q']

r3 :: [Int]
r3 = [1, 3 .. 20] -- [1, 3, ..., 17, 19]

r4 :: [Int]
r4 = [20, 19 .. 3] -- [20, 19, ..., 4, 3], must use a starter step for decreasing ranges

-- lazy evaluation enables infinite lists, SUPER COOL
ni1 :: [Int]
ni1 = take 5 [2, 4 ..] -- [2, 4, 6, 8, 10]

ni2 :: [Char]
ni2 = take 6 (cycle "ha") -- "hahaha", cycles adding each element from list ['h', 'a'] as next element

rep :: [String]
rep = repeat "ha" -- adds whole "ha" list ['h', 'a'] as next element

ni3 :: [String]
ni3 = take 6 rep -- ["ha", "ha", "ha", "ha", "ha", "ha"]

ni4 :: [String]
ni4 = replicate 6 "ha" -- ["ha", "ha", "ha", "ha", "ha", "ha"], better than 'take 6 repeat "ha"' here

-- list comprehension (creating list based off of existing list)
l7 :: [Int]
l7 = [x * 2 | x <- [1 .. 10]] -- [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]

-- can add predicate(s) to filter
l8 :: [Int]
l8 = [x * 2 | x <- [1 .. 10], x > 6] -- [14, 16, 18, 20]

boomBang :: (Integral a) => [a] -> [String]
boomBang xs = [if x < 10 then "BOOM!" else "BANG!" | x <- xs, odd x]

bb :: [String]
bb = boomBang [7 .. 13] -- ["BOOM!", "BOOM!", "BANG!", "BANG!"]

l9 :: [Int]
l9 = [x | x <- [12 .. 20], x /= 13, x /= 15, x /= 19] -- [12, 14, 16, 17, 18, 20]]

length' :: (Num a) => [t] -> a
length' xs = sum [1 | _ <- xs]

keepLowers :: String -> String
keepLowers s = [c | c <- s, c `elem` ['a' .. 'z']] -- keep only lowercase letters of a string

removeOdds xss = [[x | x <- xs, even x] | xs <- xss] -- removes odd numbers from sub-lists without flattening

-- multi-list comprehensions
l10 :: [Int]
l10 = [x * y | x <- [2, 5, 10], y <- [8, 10, 11], x * y < 50] -- [16, 20, 22, 40]

adjs :: [String]
adjs = ["scheming", "grouchy"]

nouns :: [String]
nouns = ["child", "frog", "daisy"]

l11 :: [String]
l11 = [a ++ " " ++ n | a <- adjs, n <- nouns] -- ["scheming child", "scheming frog", "scheming daisy", "grouchy child", "grouchy frog", "grouchy daisy"]

-- tuples (any size), pairs (two-element tuples)
-- lists of tuples: each tuple must be same size and have same types in same order
-- pair functions: fst, snd, zip
p :: (Int, Int)
p = (8, 11)

f :: Int
f = fst p -- 8

s' :: Int
s' = snd p -- 11

z1 :: [(Int, Char)]
z1 = zip [1 .. 5] ['a' .. 'e'] -- [(1, 'a'), (2, 'b'), (3, 'c'), (4, 'd'), (5, 'e')]

z2 :: [(Int, Char)]
z2 = zip [1 .. 5] ['a' .. 'c'] -- [(1, 'a'), (2, 'b'), (3, 'c')], cuts off after shorter list ends

z3 :: [(Int, Char)]
z3 = zip [1 ..] ['a' .. 'c'] -- [(1, 'a'), (2, 'b'), (3, 'c')], can use infinite list due to lazy eval!

-- challenge: what right triangle has sides that add up to 24? (side lengths are naturals <= 10)
rt :: [(Int, Int, Int)]
rt = [(a, b, c) | c <- [1 .. 10], b <- [1 .. c], a <- [1 .. b], c ^ 2 == a ^ 2 + b ^ 2, a + b + c == 24]