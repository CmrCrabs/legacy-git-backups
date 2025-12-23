-- Informatics 1 - Functional Programming
-- Class Test 2025

module ClassExam where

import Data.Char
import Test.QuickCheck

-- Problem 1

-- a

f :: String -> Int
f str = sum [ ord x | x <- str, isAlpha x ] 

-- b

g :: String -> Int
g [] = 0
g (x:xs) 
  | isAlpha x = ord x + g xs
  | otherwise = g xs

-- c

h :: String -> Int
h str = foldr (+) 0 (map ord (filter isAlpha str))

-- d

prop_fgh :: String -> Bool
prop_fgh str = (h str == g str) && (h str == f str)

-- Problem 2

-- a

c :: String -> String -> Bool
c st1 st2 = and [ x == y | (x,y) <- zip st1 st2, isAlpha x && isAlpha y]  

-- b

d :: String -> String -> Bool
d _ [] = True
d [] _ = True
d (x:xs) (y:ys)
  | isAlpha x && isAlpha y = (x == y) && d xs ys
  | otherwise = d xs ys

-- c

prop_cd :: String -> String -> Bool
prop_cd st1 st2 = c st1 st2 == d st1 st2
