module Tutorial3 where

import Data.Char
import Data.List
import Test.QuickCheck


-- These are some helper functions for makeKey and makeKey itself.
-- Exercises continue below.

rotate :: Int -> [Char] -> [Char]
rotate k list | 0 <= k && k <= length list = drop k list ++ take k list
              | otherwise = error "Argument to rotate too large or too small"

--  prop_rotate rotates a list of lenght l first an arbitrary number m times,
--  and then rotates it l-m times; together (m + l - m = l) it rotates it all
--  the way round, back to the original list
--
--  to avoid errors with 'rotate', m should be between 0 and l; to get m
--  from a random number k we use k `mod` l (but then l can't be 0,
--  since you can't divide by 0)

prop_rotate :: Int -> String -> Bool
prop_rotate k str = rotate (l - m) (rotate m str) == str
                        where l = length str
                              m = if l == 0 then 0 else k `mod` l

alphabet = ['A'..'Z']

makeKey :: Int -> [(Char, Char)]
makeKey k = zip alphabet (rotate k alphabet)

-- ** Caesar Cipher Exercises

-- 1.
lookUp :: Char -> [(Char, Char)] -> Char
lookUp char pairs = case [ b | (a, b) <- pairs, a == char] of
  (b:_) -> b
  [] -> ' ' 

lookUpRec :: Char -> [(Char, Char)] -> Char
lookUpRec _ [] = ' '
lookUpRec c ((a, b):pairs)
  | a == c = b
  | otherwise = lookUpRec c pairs

prop_lookUp :: Char -> [(Char, Char)] -> Bool
prop_lookUp c p = lookUp c p == lookUpRec c p  

-- 2.
encipher :: Int -> Char -> Char
encipher offset char = lookUp char (makeKey offset)

-- 3.
normalise :: String -> String
normalise str = [ toUpper c | c <- str, isAlpha c]

normaliseRec :: String -> String
normaliseRec [] = []
normaliseRec (x:xs)
  | isAlpha x = toUpper x : normaliseRec xs 
  | otherwise = normaliseRec xs

prop_normalise :: String -> Bool
prop_normalise str = normalise str == normaliseRec str

-- 4.
enciphers :: Int -> String -> String
enciphers offset str = [ encipher offset c | c <- normalise str]

-- 5.
reverseKey :: [(Char, Char)] -> [(Char, Char)]
reverseKey [] = []
reverseKey x = [ (b, a) | (a,b) <- x ]  

reverseKeyRec :: [(Char, Char)] -> [(Char, Char)]
reverseKeyRec [] = []
reverseKeyRec ((a,b):xs) = (b,a) : reverseKeyRec xs

prop_reverseKey :: [(Char, Char)] -> Bool
prop_reverseKey x = reverseKey x == reverseKeyRec x

-- 6.
decipher :: Int -> Char -> Char
decipher offset char =  lookUp char (reverseKey (makeKey offset))

decipherStr :: Int -> String -> String
decipherStr offset str = [ decipher offset ct | ct <- str, isUpper ct]

