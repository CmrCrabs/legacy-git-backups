module Tutorial1 where

import PicturesSVG -- needed for the optional chess part
import Test.QuickCheck


-- 2.
double :: Int -> In
double x = x + x

square :: Int -> Int
square x = x * x

-- 3.
isTriple :: Int -> Int -> Int -> Bool
isTriple a b c = square a + square b == square c

-- 4.
leg1 :: Int -> Int -> Int
leg1 x y = square x - square y

leg2 :: Int -> Int -> Int
leg2 x y = 2 * y * x

hyp :: Int -> Int -> Int
hyp x y = square x + square y 

-- 5.
prop_triple :: Int -> Int -> Bool
prop_triple x y = isTriple (leg1 x y) (leg2 x y) (hyp x y)

-- utils
iknight = invert knight

-- 8.
pic1 :: Picture
pic1 = above (beside knight iknight) (beside iknight knight)

pic2 :: Picture
pic2 = above (beside knight iknight) (flipV (beside knight iknight))

-- ** Functions

twoBeside :: Picture -> Picture
twoBeside x = beside x (invert x)

-- 9.
twoAbove :: Picture -> Picture
twoAbove x = above x (invert x)

fourPictures :: Picture -> Picture
fourPictures x = beside (twoAbove x) (twoAbove (invert x)) 

10.
a)
emptyRow :: Picture
emptyRow = repeatH 4 (beside whiteSquare blackSquare)

b)
otherEmptyRow :: Picture
otherEmptyRow = flipV emptyRow
-- c)
middleBoard :: Picture
middleBoard = repeatV 2 (above emptyRow otherEmptyRow) 

royal = beside king queen
board_left = beside (beside rook knight) bishop
board_right = beside (beside bishop knight) rook
major_white = beside (beside board_left royal) board_right 
major_black = invert (beside (beside board_left (flipV royal)) board_right )

pawns = repeatH 8 pawn

-- d)
whiteRow :: Picture
whiteRow = above (over pawns emptyRow) (over major_white otherEmptyRow) 
blackRow :: Picture
blackRow = above (over major_black emptyRow) (over (invert pawns) otherEmptyRow)

-- e)
populatedBoard :: Picture
populatedBoard = above (above blackRow middleBoard) whiteRow

