module Tutorial2 where

import Data.Char
import Data.List
import Test.QuickCheck


-- 1. inRange
inRange :: Int -> Int -> [Int] -> [Int]
inRange lo hi xs = [ x | x <- xs, (x >= lo) && (x <= hi) ] 

-- 2. multDigits
multDigits :: String -> Int
multDigits str = product [ digitToInt c | c <- str, isDigit(c)]

countDigits :: String -> Int
countDigits str = sum [ 1 | c <- str, isDigit(c)] 

prop_multDigits :: String -> Bool
prop_multDigits str = multDigits str <= 9 ^ (countDigits str) 

-- 3. capitalise and title
capitalise :: String -> String
capitalise [ ] = [ ]
capitalise (x:xs) = toUpper x : [ toLower c | c <- xs ]

title :: [String] -> [String]
title [ ] = [ ]
title (x:xs) = capitalise x : [ capLen w | w <- xs ]

capLen :: String -> String
capLen word
  | length word > 3 = capitalise word
  | otherwise = [ toLower c | c <- word ]

-- 4. score and totalScore
vowels = "aeiouAEIOU"
score :: Char -> Int
score x
  | isUpper x && x `elem` vowels = 3
  | isUpper x = 2
  | x `elem` vowels = 2
  | isAlpha x = 1
  | otherwise = 0

totalScore :: String -> Int
totalScore xs = product [ score c | c <- xs, isAlpha c] 

prop_totalScore_pos :: String -> Bool
prop_totalScore_pos xs = totalScore xs >= 1 


-- ** Optional Material
-- 5. crosswordFind

crosswordFind :: Char -> Int -> Int -> [String] -> [String]
crosswordFind letter pos len words = [
  w 
  | w <- [ wd | wd <- words, length wd == len ]
  , w!!pos == letter ]

-- 6. search
search :: String -> Char -> [Int]
-- search str goal = [
--   fst t
--   | t <- (zip [0..(length str)] str)
--   , snd t == goal ]
search str goal =  [ a | (a, b) <- zip [0..] str, b == goal]

-- check that the count of returned indexes is equal to the number of instances of the goal character
prop_search :: String -> Char -> Bool
prop_search str goal = length (search str goal) == length [c | c <- str, c == goal]

