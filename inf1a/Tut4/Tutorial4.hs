module Tutorial4 where

import Data.Char
import Data.List
import Test.QuickCheck
import Data.Ratio


-- 1. doubles
-- a.
doublesComp :: [Int] -> [Int]
doublesComp x =  [ 2 * a | a <- x]

-- b.
doublesRec :: [Int] -> [Int]
doublesRec [] = []
doublesRec (x:xs)
  | xs == [] = [2 * x]
  | otherwise = 2 * x : doublesRec xs

-- c.
doublesHO :: [Int] -> [Int]
doublesHO x = map (\a -> a * 2) x

-- d.
prop_doubles :: [Int] -> Bool
prop_doubles x = doublesComp x == doublesRec x && doublesComp x == doublesHO x 

-- 2. aboves
-- a.
abovesComp :: Int -> [Int] -> [Int]
abovesComp a l = [ x | x <- l, x > a] 

-- b.
abovesRec :: Int -> [Int] -> [Int]
abovesRec _ [] = []
abovesRec a (x:xs)
  | x > a = x : abovesRec a xs
  | otherwise = abovesRec a xs

-- c.
abovesHO :: Int -> [Int] -> [Int]
abovesHO a l = filter (\x -> x > a) l

-- d.
prop_aboves :: Int -> [Int] -> Bool
prop_aboves a x= abovesComp a x == abovesRec a x && abovesComp a x == abovesHO a x

-- 3. parity
-- a.
xor :: Bool -> Bool -> Bool
xor a b 
  | a && b = False
  | a || b = True
  | not a || not b = False

-- b.
parityRec :: [Bool] -> Bool
parityRec [] = True
parityRec (x:xs)
  | x = True `xor` parityRec xs
  | not x = False `xor` parityRec xs

-- c.
parityHO :: [Bool] -> Bool
parityHO [] = True
parityHO x =  foldr (xor) True x

-- d.
prop_parity :: [Bool] -> Bool
prop_parity x = parityHO x == parityRec x

-- 4. allcaps
-- a.
allcapsComp :: String -> Bool
allcapsComp str = and [ isUpper a | a <- str, isLetter a]

-- b.
allcapsRec :: String -> Bool
allcapsRec [] = and []
allcapsRec (x:xs)
  | isUpper x = allcapsRec xs
  | not (isLetter x) = allcapsRec xs
  | otherwise = False

-- c.
allcapsHO :: String -> Bool
allcapsHO str = foldr (&&) True (map (\c -> isUpper c) (filter (\c -> isLetter c) str))

-- d.
prop_allcaps :: String -> Bool
prop_allcaps x = allcapsComp x == allcapsRec x && allcapsComp x == allcapsHO x


-- ** Optional material
-- Matrix manipulation

type Matrix = [[Rational]]

-- 5
-- a.
uniform :: [Int] -> Bool
uniform (x:xs) = all (\a -> a == x) xs

width :: Matrix -> Int
width (m:_) = length m

height :: Matrix -> Int
height m = length m

-- b.
valid :: Matrix -> Bool
valid [] = False
valid (m:ms) = 
  height (m:ms) >= 1 &&
  width (m:ms) >= 1 &&
  (and [ length x == length m | x <- ms])

-- 6.
plusRow :: [Rational] -> [Rational] -> [Rational]
plusRow a b = zipWith (+) a b

plusM :: Matrix -> Matrix -> Matrix
plusM a b 
  | not ((valid a) && (valid b)) = error "not valid"
  | otherwise = [ plusRow ax bx | ax <- a, bx <- b ]

-- 7.
dot :: [Rational] -> [Rational] -> Rational
dot a b = sum (zipWith (*) a b)

timesM :: Matrix -> Matrix -> Matrix
timesM a b 
  | not ((valid a) && (valid b)) = error "not valid"
  | not (height a == width b) = error "incorrect dimensions"
  | otherwise = [ 
      [ dot ax bx | bx <- transpose b ] 
      | ax <- a 
    ]
