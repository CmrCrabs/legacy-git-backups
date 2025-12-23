module Tutorial9 where

-- Sudoku solver
-- Based on Bird, "Thinking Functionally with Haskell"

import Data.List (sort,nub,(\\),transpose,genericLength)
import Data.String (lines,unlines)
import Test.QuickCheck

-- Representing Sudoku puzzles

type Row a    = [a]
type Matrix a = [Row a]
type Digit    = Char

-- Examples from websudoku.com

easy :: Matrix Digit
easy = ["    345  ",
        "  89   3 ",
        "3    2789",
        "2 4  6815",
        "    4    ",
        "8765  4 2",
        "7523    6",
        " 1   79  ",
        "  942    "]

medium :: Matrix Digit
medium = ["   4 6 9 ",
          "     3  5",
          "45     86",
          "6 2 74  1",
          "    9    ",
          "9  56 7 8",
          "71     64",
          "3  6     ",
          " 6 9 2   "]

hard :: Matrix Digit
hard = ["9 3  42  ",
        "4 65     ",
        "  28     ",
        "     5  4",
        " 67 4 92 ",
        "1  9     ",
        "     87  ",
        "     94 3",
        "  83  6 1"]

evil :: Matrix Digit
evil = ["  9      ",
        "384   5  ",
        "    4 3  ",
        "   1  27 ",
        "2  3 4  5",
        " 48  6   ",
        "  6 1    ",
        "  7   629",
        "     5   "]

-- Another example, from Bird's book

book :: Matrix Digit
book = ["  4  57  ",
        "     94  ",
        "36      8",
        "72  6    ",
        "   4 2   ",
        "    8  93",
        "4      56",
        "  53     ",
        "  61  9  "]

-- Printing Sudoku puzzles

group :: [a] -> [[a]]
group = groupBy 3

groupBy :: Int -> [a] -> [[a]]
groupBy n [] = []
groupBy n xs = take n xs : groupBy n (drop n xs)

intersperse :: a -> [a] -> [a]
intersperse sep []     = [sep]
intersperse sep (y:ys) = sep : y : intersperse sep ys

showRow :: String -> String
showRow = concat . intersperse "|" . group

showGrid :: Matrix Digit -> [String]
showGrid = showCol . map showRow
  where
    showCol = concat . intersperse [bar] . group
    bar     = replicate 13 '-'

put :: Matrix Digit -> IO ()
put = putStrLn . unlines . showGrid

-- 1.
choice :: Digit -> [Digit]
choice ' ' = [ c | c <- "123456789" ]
choice c = [c]

choices :: Matrix Digit -> Matrix [Digit]
choices m = [ [choice c | c <- row ] | row <- m ] 

-- 2.
splits :: [a] -> [(a, [a])]
splits xs  =
  [ (xs!!k, take k xs ++ drop (k+1) xs) | k <- [0..n-1] ]
  where
  n = length xs

-- for every set of digits, p(rune) <all the known digits> <the digits to be pruned>
pruneRow :: Row [Digit] -> Row [Digit]
pruneRow row =
  [
    p [ head d | d <- row, length d == 1 ] cell
    | cell <- row
  ]
  where
  p :: [Digit] -> [Digit] -> [Digit]
  p singles [c] = [c]
  p singles digits = [ d | d <- digits, not (d `elem` singles)]


-- this code builds on pruneRow to also prune columns and boxes

pruneBy :: (Matrix [Digit] -> Matrix [Digit]) -> Matrix [Digit] -> Matrix [Digit]
pruneBy f = f . map pruneRow . f

rows, cols, boxs :: Matrix a -> Matrix a
rows = id
cols = transpose
boxs = map ungroup . ungroup . map cols . group . map group
  where
    ungroup :: Matrix a -> [a]
    ungroup = concat

prune :: Matrix [Digit] -> Matrix [Digit]
prune = pruneBy boxs . pruneBy cols . pruneBy rows

-- 3.
close :: Eq a => (a -> a) -> a -> a
close g x | g x == x = x
          | otherwise = close g (g x)

single :: [Digit] -> Bool
single [d] = True
single _   = False

the :: [Digit] -> Digit
the [d] = d

extract :: Matrix [Digit] -> Matrix Digit
extract mat | all (all single) mat = map (map the) mat

-- 4.
solve :: Matrix Digit -> Matrix Digit
solve m = extract (close prune (choices m))


-- ** Optional Material

-- 5.
failed :: Matrix [Digit] -> Bool
failed m = or [or [ length c == 0 | c <- row ] | row <- m ]

-- 6.
solved :: Matrix [Digit] -> Bool
solved m = and [and [ length c == 1 | c <- row ] | row <- m ]

-- 7.
shortest :: Matrix [Digit] -> Int
shortest m = minimum [ length ds | row <- m, ds <- row, length ds > 1 ]

-- 8.
expand :: Matrix [Digit] -> [Matrix [Digit]]
expand m = [ preMat ++ [preRow ++ [[d]] ++ postRow] ++ postMat
           | d <- ds ]
  where
    p = (\ds -> length ds == shortest m)
    (preMat, row:postMat) = break (any p) m
    (preRow, ds:postRow) = break p row

-- 9.
search :: Matrix Digit -> [Matrix Digit]
search p = s (choices p) where
  s :: Matrix [Digit] -> [Matrix Digit]
  s m | solved m' && valid (extract m') = [extract m']
      | solved m' || failed m' = []
      | otherwise  = concatMap s (expand m')
      where
        m' = close prune m

valid :: Matrix Digit -> Bool
valid m = v (rows m) && v (cols m) && v (boxs m) where
  v = all (\l -> length (nub l) == 9)

-- display puzzle and then solution(s) found by search

puzzle :: Matrix Digit -> IO ()
puzzle g = put g >> puts (search g) >> putStrLn "***"
     where puts = sequence_ . map put
       
main :: IO ()
main = puzzle easy >>
       puzzle medium >>
       puzzle hard >>
       puzzle evil

