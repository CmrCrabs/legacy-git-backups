module Sudoku where
  
import Data.List
import Data.Char(intToDigit)
import System.CPUTime
import Text.Printf

-- [ The following lines code our language of forms ]
    
data Literal atom = P atom | N atom
                    deriving (Eq, Show)

data Clause atom = Or [Literal atom]
                   deriving (Eq, Show)

data Form atom = And [Clause atom]
                 deriving (Eq, Show)

neg :: Literal atom -> Literal atom
neg (P a) = N a
neg (N a) = P a                          

(<&&>) :: Form a -> Form a -> Form a
And xs <&&> And ys = And ( xs ++ ys )

-- | The next three functions correspond to the optimized
-- implementation of the DPLL algorithm, as seen in the textbook
-- in chapter 19.
                    
(<<) :: Eq atom => [Clause atom] -> Literal atom -> [Clause atom]
cs << l = [ Or (delete (neg l) ls)
               | Or ls <- cs, not (l `elem` ls) ]

dpll :: Eq atom => Form atom -> [[Literal atom]]
dpll f =
    case prioritise f of
      [] -> [[]] -- the trivial solution
      Or [] : cs -> [] -- no solution
      Or (l:ls) : cs ->
          [ l : ls | ls <- dpll (And (cs << l)) ]
          ++
          [ neg l : ls | ls <- dpll (And (Or ls : cs << neg l)) ]

prioritise :: Form atom -> [Clause atom]
prioritise (And cs) = sortOn (\(Or ls) -> length ls) cs

-- [ Now we start playing Sudoku ]
-- 
-- We follow the description in the textbook in chapter 19.

sudoku :: Form (Int, Int, Int)
sudoku = allFilled <&&> noneFilledTwice
         <&&> rowsComplete <&&> columnsComplete <&&> squaresComplete
         <&&> rowsNoRepetition <&&> columnsNoRepetition <&&> squaresNoRepetition

allFilled :: Form (Int,Int,Int)
allFilled = And [ Or [ P (i,j,n) | n <- [1..9] ]
                | i <- [1..9], j <- [1..9] ]

noneFilledTwice :: Form (Int,Int,Int)
noneFilledTwice = And [ Or [ N (i, j, n), N (i, j, n') ]
                      | i <- [1..9], j <- [1..9],
                        n <- [1..9], n' <- [1..(n-1)]]

rowsComplete :: Form (Int,Int,Int)
rowsComplete = And [ Or [ P (i, j, n) | j <- [1..9] ]
                   | i <- [1..9], n <- [1..9] ]

columnsComplete :: Form (Int,Int,Int)
columnsComplete = And [ Or [ P (i, j, n) | i <- [1..9] ]
                      | j <- [1..9], n <- [1..9] ]

squaresComplete :: Form (Int,Int,Int)
squaresComplete = And [ Or [ P (i, j, n) 
                           | i <- [(3 * a + 1)..(3 * a + 3)], 
                             j <- [(3 * b + 1)..(3 * b + 3)] 
                           ]  
                      | a <- [0..2], 
                        b <- [0..2], 
                        n <- [1..9] 
                      ]

rowsNoRepetition :: Form (Int,Int,Int)
rowsNoRepetition = And [ Or [ N (i, j, n), N (i, j', n) ]
                       | i <- [1..9], n <- [1..9],
                         j <- [1..9], j' <- [1..(j-1)] ]

columnsNoRepetition :: Form (Int,Int,Int)
columnsNoRepetition = And [ Or [ N (i, j, n), N (i', j, n) ]
                          | i <- [1..9],
                            i' <- [1..(i-1)],
                            j <- [1..9], 
                            n <- [1..9]
                          ]
                      
squaresNoRepetition :: Form (Int,Int,Int)
squaresNoRepetition = And [ 
                            Or [ N (i, j, n), N (i', j', n) ]
                          | a  <- [0..2], 
                            b  <- [0..2], 
                            n  <- [1..9],
                            i  <- [(3 * a + 1)..(3 * a + 3)],
                            j  <- [(3 * b + 1)..(3 * b + 3)],
                            i' <- [(3 * a + 1)..(3 * a + 2)],
                            j' <- [(3 * b + 1)..(3 * b + 2)]
                          ]
-- for all grids, there does not exist F(ijn) and F(i'j'n)
-- for all grids, there does not exist not F(ijn) or not F(i'j'n)


solutions :: Form (Int, Int, Int) -> [[Literal (Int, Int, Int)]]
solutions problem = dpll (sudoku <&&> problem)

-- | A sample Sudoku problem. You may replace this with your own problem.

sudokuProblem :: Form (Int, Int, Int)
sudokuProblem = And [ Or [P (1,8,8)], Or [P (1,9,2)], Or [P (2,1,6)]
                    , Or [P (2,4,4)], Or [P (4,1,4)], Or [P (4,5,7)]
                    , Or [P (4,6,2)], Or [P (5,1,5)], Or [P (5,7,4)]
                    , Or [P (5,8,3)], Or [P (6,5,1)], Or [P (7,4,8)]
                    , Or [P (7,7,6)], Or [P (8,2,8)], Or [P (8,3,1)]
                    , Or [P (9,2,2)], Or [P (9,9,7)]]
                
-- [ Pretty printing for Sudoku problems and solutions ]
--
-- The following (optional) functions give you nice and easy to read
-- representations of Sudoku problems and solutions. We do not expect
-- you to understand their definitions.
-- 
-- You may find them useful to check that sudokuProblem is a correct
-- encoding of the problem you are trying to solve, and also to
-- visualise the solutions.
--
-- There are three functions you may want to use:
-- 
-- printProblem sudokuProblem
--   pretty prints sudokuProblem
--
-- printAllSolutions sudokuProblem
--   pretty prints all solutions to sudokuProblem
--   (please note that this may take a while)
-- 
-- printSolution . head . solutions $ sudokuProblem
--   pretty prints the first solution to sudokuProblem
--   (please note that this may take a while)

toLiterals :: Form atom -> [Literal atom]
toLiterals (And clauses) = concat $ map unpack clauses
    where unpack (Or literals) = literals
                                 
showSquares :: [Literal (Int,Int,Int)] -> String
showSquares lits =
  let pos = [ a | P a <- lits ]
  in
   [ (intToDigit.last) [ k | k <-[0..9]
                       , (i, j, k)`elem`pos || k == 0 ]
   | i <- [1..9], j <- [1..9] ]
  
-- | pretty takes an 81 digit string and presents it in sudoku form
-- using unicode -- suitable for putStrLn
pretty :: String -> String
pretty = ((tl++dsh++dn++dsh++dn++dsh++tr++"\n"++vt++" ")++)
         . (++(" "++vt++" \n"++bl++dsh++up++dsh++up++dsh++br))
         . intercalate (" "++vt++"\n"++vl++dsh++pl++dsh++pl++dsh++vr++" \n"++vt++" ")
         . map (intercalate (" "++vt++"\n"++vt++" ")) . byThree
         . map (intercalate (" "++vt++" ")). byThree
         . map (intersperse ' ')  . byThree
         . map (\d -> if d == '0' then '\x005F' else d)
  where
    byThree :: [a] -> [[a]]
    byThree (a : b : c : xs) = [a,b,c] : byThree xs
    byThree [] = []
    tl = "\x250F" -- topleft
    tr = "\x2513" -- topright
    bl = "\x2517" -- botleft
    br = "\x251B" -- botright
    dn = "\x2533"
    up = "\x253B"
    vl = "\x2523" -- vertleft
    vr = "\x252B" -- vertright
    vt = "\x2503" -- vertical
    pl = "\x254B" -- plus
    dsh = take 7 $ repeat '\x2501'
  
printProblem :: Form (Int, Int, Int) -> IO ()
printProblem = putStrLn . pretty . showSquares . toLiterals

printSolution :: [Literal (Int, Int, Int)] -> IO ()
printSolution = putStrLn . pretty . showSquares

printAllSolutions :: Form (Int, Int, Int) -> IO ()
printAllSolutions = mapM_ printSolution . solutions

-- Answer to exercise 2

{- 

Type your answer to exercise 2 here.

* minimal and complete description:
allFilled,
noneFilledTwice,
rowsComplete,
columnsComplete,
squaresComplete

* comparing speeds:

** minimal&complete:
Computation time: 7.463 sec

** (minimal&complete) + rowsNoRepetition:
Computation time: 8.808 sec

** (minimal&complete) + columnsNoRepetition:
Computation time: 8.879 sec

** (minimal&complete) + squaresNoRepetition:
Computation time: 8.750 sec

** (minimal&complete) + rowsNoRepetition + columnsNoRepetition:
Computation time: 10.316 sec

** (minimal&complete) + rowsNoRepetition + columnsNoRepetition + squaresNoRepetition:
Computation time: 11.601 sec

from these:
- it seems the squaresNoRepetition provides the largest speedup,
- rowsNoRepetition and columnsNoRepetition provide only marginally different speedups
-}
time :: IO t -> IO t
time a = do
    start <- getCPUTime
    v <- a
    end   <- getCPUTime
    let diff = (fromIntegral (end - start)) / (10^12)
    printf "Computation time: %0.3f sec\n" (diff :: Double)
    return v

min_compl :: Form (Int, Int, Int)
min_compl= allFilled <&&> noneFilledTwice
         <&&> rowsComplete <&&> columnsComplete <&&> squaresComplete 
         <&&> sudokuProblem

mc_rnr :: Form (Int, Int, Int)
mc_rnr = allFilled <&&> noneFilledTwice
         <&&> rowsComplete <&&> columnsComplete <&&> squaresComplete
         <&&> rowsNoRepetition 
         <&&> sudokuProblem

mc_cnr :: Form (Int, Int, Int)
mc_cnr = allFilled <&&> noneFilledTwice
         <&&> rowsComplete <&&> columnsComplete <&&> squaresComplete
         <&&> columnsNoRepetition
         <&&> sudokuProblem

mc_snr :: Form (Int, Int, Int)
mc_snr = allFilled <&&> noneFilledTwice
         <&&> rowsComplete <&&> columnsComplete <&&> squaresComplete
         <&&> squaresNoRepetition
         <&&> sudokuProblem

mc_rcnr :: Form (Int, Int, Int)
mc_rcnr = allFilled <&&> noneFilledTwice
         <&&> rowsComplete <&&> columnsComplete <&&> squaresComplete
         <&&> rowsNoRepetition <&&> columnsNoRepetition
         <&&> sudokuProblem


mc_rcsnr :: Form (Int, Int, Int)
mc_rcsnr = allFilled <&&> noneFilledTwice
         <&&> rowsComplete <&&> columnsComplete <&&> squaresComplete
         <&&> rowsNoRepetition <&&> columnsNoRepetition <&&> squaresNoRepetition
         <&&> sudokuProblem



main = do
    time $ (head . solutions $ min_compl) `seq` return ()
    time $ (head . solutions $ mc_rnr   ) `seq` return ()
    time $ (head . solutions $ mc_cnr   ) `seq` return ()
    time $ (head . solutions $ mc_snr   ) `seq` return ()
    time $ (head . solutions $ mc_rcnr  ) `seq` return ()
    time $ (head . solutions $ mc_rcsnr ) `seq` return ()
