-- check type in ghci: :t exp, can wrap infix operators like: :t (==)

-- Int (bounded by processor) vs. Integer (unbounded)
-- Float (real numbers) vs. Double (twice float's precision)
-- Bool
-- Char ([Char] are colloquially Strings)
-- Tuples: () -> empty tuple, (t1, ..., tn) -> composed of types of sub-elements
-- Parametric Polymorphism: a -> a       (a can be any type but must be the same throughout)
--                          (a, b) -> a  (a and b CAN be the same type but don't have to be)
-- Typeclass: define required behavior (similar to interface), like Subtype Polymorphism
--            (Eq a) => a -> a -> Bool   (a must be a member of Eq class because the function uses == or /= in the body)
--            ^^^^^^ = class constraint, can have multiple (one per polymorphic type name) separated by commas
--  - important typeclasses: Eq (implement == and /=), Ord (implement compare -> Ordering (GT, LT, EQ), enables > >= < <= min max, also an Eq),
--                           Show (implement show to convert to string), Read (implement read to convert from string to type),
--                           Enum (can iterate, succ (successor), pred (predecessor)),
--                           Bounded (define minBound and maxBound constants),
--                           Num (able to act like a number, enables + - * negate abs signum, also Show and Eq),
--                           Integral (able to act as any whole number, e.g. Int and Integer, support div and mod),
--                           Floating (able to act as any decimal number, e.g. Float and Double),
--                           Fractional (support / and recip)
r1 :: [Int]
r1 = [read c + 1 | c <- [show n | n <- [1 .. 5]]] -- [2, 3, 4, 5, 6], read c will not parse as it's not a definitively decidable type

comps :: [Ordering]
comps = [LT .. GT] -- [LT, EQ, GT], Ordering is an Enum!

b :: Char
b = succ 'A' -- 'B', Char is an Enum!

t :: Bool
t = succ False -- True, order is False then True, pred False and succ True -> error

minT :: (Char, Int, Bool)
minT = minBound :: (Char, Int, Bool) -- ('\NUL',-9223372036854775808,False), tuple of all the mins!

x :: Float
x = 20 :: Float -- 20.0, whole numbers act like polymorphic constants, can act like any Num type

-- explicit type annotations: exp :: Type
r2 :: [Int]
r2 = read "[1, 2, 3, 4]" :: [Int]

-- error, mismatching types, even though both Num: (5 :: Int) * (6 :: Integer)
y = 5 * (6 :: Integer) -- 30, ok because whole numbers (e.g. 5) can act as any Num type

-- useful function: fromIntegral :: (Num b, Integral a) => a -> b
-- error, mismatching types: length "hello" + 3.2
z :: Float
z = fromIntegral (length "hello") + 3.2