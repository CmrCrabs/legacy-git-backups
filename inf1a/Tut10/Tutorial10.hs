module Tutorial10 where

import Test.QuickCheck
import Control.Monad
import Data.Char

-- Question 1

-- 1a

ok :: String -> Bool
ok str = (and $ map isLower str) && length str < 6
-- 1b

f strs = g $ filter ok strs
  where
    g [] = "zzzzz"
    g ok = minimum ok

-- 1c

g :: [String] -> String
g strs = h $ isOK strs
  where
    isOK [] = []
    isOK (x:xs) | ok x = x : isOK xs
                | otherwise = isOK xs
    h [] = "zzzzz"
    h (x:xs) = min x (h xs)

-- 1d
h strs = i $ filter ok strs
  where
    i [] = "zzzzz"
    i (x:xs) = foldr min x xs

-- Question 2

-- 2a

i :: [a] -> [a] -> [a]
i (x:xs) (y:ys) = xs ++ [y]

-- 2b

j :: [[a]] -> [[a]]
j (x:xs) = zipWith i (x:xs) (xs ++ [x])

-- 2c

k :: [[a]] -> [[a]]
k (x:xs) = z (x:xs) (xs ++ [x])
  where
    z (x:xs) (y:ys) = [i x y] ++ z xs ys
    z _ _ = []

-- Question 3

data Prop = X
          | Y
          | T
          | F
          | Not Prop
          | Prop :&&: Prop
          | Prop :||: Prop
          | Prop :->: Prop
  deriving (Eq, Show)

instance Arbitrary Prop where
  arbitrary = sized gen
    where
    gen 0 =
      oneof [ return X,
              return Y,
              return T,
              return F ]
    gen n | n>0 =
      oneof [ return X,
              return Y,
              return T,
              return F,
              liftM Not prop,
              liftM2 (:&&:) prop prop,
              liftM2 (:||:) prop prop,
              liftM2 (:->:) prop prop]
      where
      prop = gen (n `div` 2)

-- 3a

eval :: Bool -> Bool -> Prop -> Bool
eval _ _ T = True
eval _ _ F = False
eval x _ X = x
eval _ y Y = y
eval x y (Not p) = not $ eval x y p
eval x y (p1 :&&: p2) = eval x y p1 && eval x y p2
eval x y (p1 :||: p2) = eval x y p1 || eval x y p2
eval x y (p1 :->: p2) = eval x y p2 || not (eval x y p1)


-- 3b

simple :: Prop -> Bool
simple T = True
simple F = True
simple X = True
simple Y = True
simple (Not T) = False
simple (Not F) = False
simple (T :&&: _) = False
simple (_ :&&: T) = False
simple (F :&&: _) = False
simple (_ :&&: F) = False
simple (T :||: _) = False
simple (_ :||: T) = False
simple (F :||: _) = False
simple (_ :||: F) = False

simple (p :&&: q) = simple p && simple q
simple (p :||: q) = simple p && simple q
simple (p :->: q) = simple p && simple q
simple (Not p) = simple p

-- 3c

simplify :: Prop -> Prop

simplify p
  | simple p = p
  | otherwise = simplify (s p)
  where
    s T = T
    s F = F
    s X = X
    s Y = Y
    s (Not T) = F
    s (Not F) = T
    s (Not X) = Not X
    s (Not Y) = Not Y
    s (F :&&: _) = F
    s (_ :&&: F) = F
    s (T :||: _) = T
    s (_ :||: T) = T
    s (F :->: p) = T
    s (_ :->: T)    = T

    s (Not (Not p)) = simplify p
    s (T :&&: p)    = simplify p
    s (p :&&: T)    = simplify p
    s (F :||: p)    = simplify p
    s (p :||: F)    = simplify p
    s (T :->: p)    = simplify p
    s (p :->: F)    = simplify (Not p)

    s (Not (p :&&: q)) = simplify (Not p) :||: simplify (Not q)
    s (Not (p :||: q)) = simplify (Not p) :&&: simplify (Not q)
    s (p :&&: q)       = simplify p :&&: simplify q
    s (p :||: q)       = simplify p :||: simplify q
    s (p :->: q)       = simplify q :||: Not (simplify p)
