-- add module functions to top-level in GHCI: :m + ModuleName1 ... ModuleNameN
-- - e.g. :m Data.List, :m Data.List Data.Set Data.Map
-- selectively import: import ModuleName (funcName1, ..., funcNameN)
-- - e.g. import Data.List (nub, sort)
-- import all of a module EXCEPT 'funcName' (might use if implementing own version): import ModuleName hiding (funcName)
-- - e.g. import Data.List hiding (nub)
-- alternatively, use (requires using ModuleName.funcName in code): import qualified ModuleName as ShortName
-- - e.g. import qualified Data.Map as M

import Data.Char (chr, ord)
import Data.Function (on)
import Data.List (group, groupBy, intercalate, intersect, intersperse, nub, sort, sortBy, transpose, union, (\\))
import Data.Map qualified as Map (Map, empty, fromListWith, insert)
import Geometry.Cube qualified as Cube (area)

numUniques :: (Eq a) => [a] -> Int
numUniques = length . nub -- nub removes duplicate entries in a list

s1 :: String
s1 = intersperse '-' "SPELLING" -- injects first param between each element of second param list

s2 :: String
s2 = intercalate "-" ["I", "have", "dashes!"] -- injects first param list between each element of second param list then flattens

t :: [[Int]]
t = transpose [[1, 2, 3], [4, 5, 6], [7, 8, 9]] -- [[1, 4 ,7], [2, 5, 8], [3, 6, 9]], swaps sub-array 'rows' to 'columns'

-- Q: add together math expressions 3x2 + 5x + 9, 10x3 + 9, 8x3 + 5x2 + x - 1
m :: [Int]
m = map sum $ transpose [[0, 3, 5, 9], [10, 0, 0, 9], [8, 5, 1, -1]] -- [18, 8, 6, 17], add constants for each power of x together

-- foldl'/foldl1': foldl/foldr thunk applying func to acc and next (lazy eval) until used whereas foldl'/foldl1' update acc each next (strict eval)
-- - can cause stack overflow if foldl/foldr over LARGE data - create humongous thunk chain!
-- https://wiki.haskell.org/Foldr_Foldl_Foldl & https://stackoverflow.com/questions/3082324/foldl-versus-foldr-behavior-with-infinite-lists
-- - BOTH foldr/foldl start processing list from left but associate differently! foldr doesn't need to "find" the end of the list to start
-- - use foldr for transforming a list into a list in same order
--   - foldr: right associativity (f x1 (f x2 (f x3 (f x4 ... (f xn z) ... )))):
--     - has access to first param, if second param to given func is lazy, will only eval as needed and can terminate based only on first param
--     - can short circuit
--   - foldl: left associativity (f ( ... (f (f (f (f z x1) x2) x3) x4) ...) xn):
--     - has to follow first param aaaaaaall the way down and will fail on infinite list
-- - use foldl for transforming a list into a list in reverse order
-- - use foldl' for large (not infinite) lists to avoid stack overflows or otherwise for efficiency
head' :: [a] -> a
head' = foldr1 const

h1 :: Int
h1 = head' [1 ..] -- works because const only evaluates left param (const 1 (DOESN'T CARE WHAT'S HERE))

head'' :: [a] -> a
head'' = foldl1 (\_ x -> x)

h2 :: Int
h2 = head'' [1 ..] -- infinite loop because the first param is infinite and never resolves to something you can pass even to ignore

prodLastDigit :: Int
prodLastDigit = foldr (\e acc -> if mod e 10 == 0 then 0 else mod e 10 * acc) 1 [1 .. 10 ^ 17] -- faster than foldl' because short circuiting at first 0

-- more Data.List (can always check Hoogle):
--   concat (flattens [[a]] to [a]), concatMap (map each list element then flatten),
--   splitAt (split list into tuple of lists at index (inclusive start of second)),
--   span (like splitAt but with a predicate (acts like takeWhile) to determine where to split),
--   break (like span but splits when predicate is first true), sort (type must implement Ord),
--   group (groups adjacent equal elements into sublists [a] -> [[a]]),
--   inits (recursive L->R init to a list, e.g. inits "hi": ["", "h", "hi"]),
--   tails (recursive L->R tail to a list, e.g. tails "hi": ["hi", "i", ""]),
--   isInfixOf (searches for a sublist within a list),
--   isPrefixOf (isInfixOf but only beginning of list), isSuffixOf (isInfixOf but only end of list),
--   elem (exists in list?), notElem (doesn't exist in list?),
--   elemIndex (Maybe index where element exists in list), elemIndices (list of indices where element exists in list, no Maybe since can just return [])
--   partition (tuple of elements that match predicate in first list and remnants in second list),
--   find (Maybe first element in list that matches predicate, good for when not guaranteed to find it!),
--   findIndex (Maybe index of first element that matches predicate), findIndices (list of indices of elements that match predicate),
--   zip3 .. zip7, zipWith3 .. zipWith7 (like zip and zipWith but for 3-7 arrays),
--   lines (string -> array of strings, each a 'line' of text (break on '\n')), unlines (opposite of lines),
--   words (string -> array of strings, each a 'word' of text (break on ' ')), unwords (opposite of words),
--   nub (removes all duplicate elements), delete (remove first occurrence of element in list)
--   \\ (list difference - return a list containing elements from the first list minus the elements of the second list),
--   union (return list with all elements of first list and elements of second list that do not already exist in first list),
--   intersect (return list with only elements common to both lists, retains order of first list),
--   insert (adds element to list in sorted order, i.e. before the first greater element it encounters L->R),
--   lookup (i.e. assoc, Maybe 'cdr' of tuple whose 'car' matches the lookup term)
-- NOTE: length, take, drop, splitAt, !! (index), replicate all take or return Int instead of Num for historical purposes,
--       there are generic versions of all named genericLength, genericIndex, etc.
-- NOTE: nub, delete, union, intersect, group use == to test equality,
--       the versions that take a predicate (that takes two params to check equality) instead are named nubBy, etc.
-- NOTE: sort, insert, maximum, minumum similarly have _By versions that take a predicate that returns LT EQ or GT when comparing two elements

a1 :: Bool
a1 = and [5 > 4, 6 == 6, 7 < 8, even 8] -- True

o :: Bool
o = or [6 < 3, 2 == 1, a1, odd 4] -- True

a2 :: Bool
a2 = any (> 4) [1, 3, 5] -- True

a3 :: Bool
a3 = all (> 4) [3, 5, 7, 9] -- False

-- iterate: generate infinite list based on successive application of given function to starting value, then to result, etc.
i :: [Int]
i = iterate (* 2) 1 -- [1, 2, 4, 8, 16, 32, ...], can then take or foldr something that will terminate, etc.

pow2sSub10000 :: [Int]
pow2sSub10000 = takeWhile (< 10000) $ iterate (* 2) 1

pow2gt1000 :: Int
pow2gt1000 = head $ dropWhile (< 1000) pow2sSub10000

countEach :: (Real a) => [(a, Int)]
countEach = map (\e@(x : xs) -> (x, length e)) . group . sort $ [1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 2, 2, 2, 5, 6, 7]

s3 :: String
s3 = "hello llo" \\ "hllo !!" -- "ello", ignores elements to remove that don't exist in first list

s4 :: String
s4 = "hello" `union` "alllloo" -- "helloa"

s5 :: String
s5 = "hello" `intersect` "oolllla" -- "llo"

-- "group by equality on whether elements are < 0"
groupBySign :: (Real a) => [a] -> [[a]]
groupBySign = groupBy ((==) `on` (< 0)) -- first applies (> 0) to each param then applies (==) to the results

splitSigns :: [[Int]]
splitSigns = groupBySign [-2, -1, 0, 1, 2, -3, 3] -- [[-2, -1], [0, 1, 2], [-3], [3]]

sortByLength :: [[a]] -> [[a]]
sortByLength = sortBy (compare `on` length)

-- Data.Char: isLower, isUpper, isAlpha, isAlphaNum, isDigit, isSpace, isPunctuation, isControl,
--   toLower, toUpper, digitToInt, intToDigit, ord (unicode number of char), chr (opposite of ord)
-- Get 'type' of a char w/ 'generalCategory c': e.g. Space, UppercaseLetter, OtherPunctuation, DecimalNumber, Control, etc.

caesar :: Int -> String -> String
caesar shift = map $ chr . (+ shift) . ord

coders :: Int -> (String -> String, String -> String)
coders shift = (caesar shift, caesar (-shift)) -- produces encoder and decoder

-- Data.Map (dictionaries): keys must be Ord and unique, generally use qualified import as some funcs clash with Prelude funcs
--   fromList (convert [(a, b)] -> Map a b, later entries overwrite where keys are same), empty, insert, null (i.e. empty?),
--   size (i.e. # k-v pairs), singleton (creates single k-v pair map), lookup (Maybe value), member (i.e. elem),
--   map (func transforms values), filter (func filters over values), toList (opposite of fromList), keys, elems (i.e. values),
--   fromListWith (like fromList with func (takes two 'values') to handle duplicates),
--   insertWith (like insert with func (takes two 'values') to handle duplicates)
fromList' :: (Ord k) => [(k, v)] -> Map.Map k v
fromList' = foldl (\acc (k, v) -> Map.insert k v acc) Map.empty

phoneBook :: [(String, String)]
phoneBook =
  [ ("amelia", "555-2938"),
    ("amelia", "342-2492"),
    ("freya", "452-2928"),
    ("isabella", "493-2928"),
    ("isabella", "943-2929"),
    ("isabella", "827-9162"),
    ("neil", "205-2928"),
    ("roald", "939-8282"),
    ("tenzing", "853-2492"),
    ("tenzing", "555-2111")
  ]

pbToMap :: (Ord k) => [(k, v)] -> Map.Map k [v]
pbToMap pb = Map.fromListWith (++) $ map (\(k, v) -> (k, [v])) pb

ms :: Map.Map Int Int
ms = Map.fromListWith max [(2, 3), (2, 5), (2, 100), (3, 29), (3, 22), (3, 11), (4, 22), (4, 15)] -- keeps the largest value

-- Data.Set: list of unique, Ord values
--   fromList (convert [a] -> Set a), difference (like \\ for lists), toList (opposite of fromList)
--   union, intersection, null, size, member, empty, singleton, insert, delete, map, filter - all like Data.Map
--   isSubsetOf (all elements of a in b?), isProperSubsetOf (isSubsetOf + b has more elements),
-- NOTE: removing duplicates over a large list, Set.toList . Set.fromList will be faster than nub
--   BUT requires Ord data not just Eq AND nub retains order

-- Modules export functions: see practice module in Geometry
a :: Float
a = Cube.area 3 -- 54.0