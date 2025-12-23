module Tutorial7 where

import LSystem
import Test.QuickCheck

pathExample = Go 30 :#: Turn 120 :#: Go 30 :#: Turn 120 :#: Go 30

-- 1a. copy
copy :: Int -> Command -> Command
copy 0 _  = Sit
copy n cmd = cmd :#: copy (n-1) cmd

-- 1b. polygon
polygon :: Distance -> Int -> Command
polygon x n = copy n (Go x :#: Turn (360 / fromIntegral n))

-- 2. snowflake
snowflake :: Int -> Command
snowflake x = f x :#: a :#: a :#: f x :#: a :#: a :#: f x :#: a :#: a where
  f 0 = GrabPen blue :#: Go 10 
  f x = f (x-1) :#: c :#: f (x-1) :#: a :#: a :#: f (x-1) :#: c :#: f (x-1)
  c = Turn 60
  a = Turn (-60)
 
-- 3. sierpinski
sierpinski :: Int -> Command
sierpinski x = f x where
  f 0 = GrabPen blue :#: Go 10 
  f x = g (x-1) :#: c :#: f (x-1) :#: c :#: g (x-1)
  g 0 = GrabPen green :#: Go 10 
  g x = f (x-1) :#: a :#: g (x-1) :#: a :#: f (x-1)
  c = Turn 60
  a = Turn (-60)
     

-- 5. dragon
dragon :: Int -> Command
dragon x = l x where 
  f 0 = Go 10 
  f x = f (x-1)
  l 0 = Sit
  l x = l (x-1) :#: c :#: r (x-1) :#: f (x-1) :#: c
  r 0 = Sit
  r x = a :#: f (x-1) :#: l (x-1) :#: a :#: r (x-1)
  c = Turn 90
  a = Turn (-90)

-- ** Optional Material

-- 6a. split
split :: Command -> [Command]
split Sit = []
split (a :#: b) = split a ++ split b
split c = [c]

-- 6b. join
join :: [Command] -> Command
join [] = Sit
join (x:xs) = foldl (:#:) x xs

-- 6c. equivalent
equivalent :: Command -> Command -> Bool
equivalent x y = join (split x) == join (split y)

-- 6d. testing join and split
prop_split_join :: Command -> Bool
prop_split_join c = equivalent (join (split c)) c

prop_split :: Command -> Bool
prop_split cmd = and [ False | c <- split cmd, c == Sit ]

-- 7. optimise
js :: Command -> Command
js x = join (split x)

optimised :: Command -> Bool
optimised (Go _ :#: Turn _) = True
optimised (Turn _ :#: Go _) = True
optimised (Go _ :#: Turn _ :#: Go _) = True
optimised (Turn _ :#: Go _ :#: Turn _) = True
optimised (Go _ :#: Turn _ :#: z) = optimised z
optimised (Turn _ :#: Go _ :#: z) = optimised z
optimised _ = False

optimise :: Command -> Command
optimise Sit         = Sit
optimise (Turn 0)    = Sit
optimise (Go 0)      = Sit
optimise (Sit :#: x) = optimise x
optimise (x :#: Sit) = optimise x

optimise (Turn x :#: Turn y) = Turn (x + y)
optimise (Go x :#: Go y)     = Go (x + y)

optimise x 
  | optimised (js x) = (js x) where

optimise (x :#: y) = optimise (js (optimise x :#: optimise y))
optimise x         = x

