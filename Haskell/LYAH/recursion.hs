maximum' :: (Ord a) => [a] -> a
maximum' [] = error "empty list has no maximum"
maximum' [x] = x
maximum' (x : xs) = max x (maximum' xs)

replicate' :: (Ord n, Num n) => n -> a -> [a]
replicate' n x
  | n <= 0 = []
  | otherwise = x : replicate' (n - 1) x

take' :: (Ord n, Num n) => n -> [a] -> [a]
take' _ [] = []
take' n _ | n <= 0 = []
take' n (x : xs) = x : take' (n - 1) xs

reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x : xs) = reverse' xs ++ [x]

repeat' :: a -> [a]
repeat' x = x : repeat' x

zip' :: [a] -> [b] -> [(a, b)]
zip' [] _ = []
zip' _ [] = []
zip' (x : xs) (y : ys) = (x, y) : zip' xs ys

elem' :: (Eq a) => a -> [a] -> Bool
a `elem'` [] = False
a `elem'` (x : xs)
  | a == x = True
  | otherwise = a `elem'` xs

qsort' :: (Ord a) => [a] -> [a]
qsort' [] = []
qsort' (x : xs) = lt ++ [x] ++ gt
  where
    lt = qsort' [x' | x' <- xs, x' <= x]
    gt = qsort' [x' | x' <- xs, x' > x]