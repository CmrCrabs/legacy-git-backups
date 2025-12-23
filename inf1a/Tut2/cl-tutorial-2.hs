data Thing = A | B | C | D | E deriving (Eq,Show)
things :: [Thing]
things = [ A,B,C,D,E ]
type Predicate u = u -> Bool


data Colour = Amber | Blue deriving (Eq,Show)
isBlue :: Predicate Thing
isBlue x = x `elem` [ D ]
isAmber :: Predicate Thing
isAmber x = x `elem` [ A, B, C, E ]

data Shape = Circle | Square deriving (Eq,Show)
isCircle :: Predicate Thing
isCircle x = x `elem` [ C, E ]
isSquare :: Predicate Thing
isSquare x = x `elem` [ A, B, D ]

data Size = Big | Small deriving (Eq,Show)
isSmall :: Predicate Thing
isSmall x = x `elem` [ E ]
isBig :: Predicate Thing
isBig x = x `elem` [ A, B, C, D ]

data Border = True | False deriving (Eq,Show)
hasBorder :: Predicate Thing
hasBorder x = x `elem` [A, C, D, E]

everyBlueSquareBorder :: Bool
everyBlueSquareBorder = and [ hasBorder(x) | x <- things, isBlue x && isSquare x ]
-- true

someAmberCircleBig :: Bool
someAmberCircleBig = or [ isBig x | x <- things, isAmber x && isCircle x ]
-- true

notEverySquareBlue :: Bool
notEverySquareBlue = not (or [ isBlue x | x <- things, isSquare x ])

everySquareNotBlue :: Bool
everySquareNotBlue = and [ not (isBlue x) | x <- things, isSquare x ]
