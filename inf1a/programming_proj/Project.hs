module Project ( prove, proveCount ) where

import Sequent
import Data.Foldable
import Data.List
import Data.Maybe

-------------- helpers
type Rule = (Sequent -> Maybe [Sequent])

isOr :: Prop -> Bool
isOr (_ :||: _) = True
isOr _ = False

isAnd :: Prop -> Bool
isAnd (_ :&&: _) = True
isAnd _ = False

isNot :: Prop -> Bool
isNot (Not _) = True
isNot _ = False

isImpl :: Prop -> Bool
isImpl (_ :->: _) = True
isImpl _ = False

isBimp :: Prop -> Bool
isBimp (_ :<->: _) = True
isBimp _ = False

-------------- rules
andL :: Rule
andL (ante :|=: succ)
  | not $ any isAnd ante = Nothing
  | otherwise = r . fromJust $ find isAnd ante
    where
      r prop@(p :&&: q) = Just [[p,q] ++ delete prop ante :|=: succ]

orR :: Rule
orR (ante :|=: succ)
  | not $ any isOr succ = Nothing
  | otherwise = r . fromJust $ find isOr succ
    where
      r prop@(p :||: q) = Just [ante :|=: [p,q] ++ delete prop succ]

orL :: Rule
orL (ante :|=: succ)
  | not $ any isOr ante = Nothing
  | otherwise = r . fromJust $ find isOr ante
    where
      r prop@(p :||: q) =
        Just [ p : delete prop ante :|=: succ
             , q : delete prop ante :|=: succ ]

andR :: Rule
andR (ante :|=: succ)
  | not $ any isAnd succ = Nothing
  | otherwise = r . fromJust $ find isAnd succ
    where
      r prop@(p :&&: q) =
        Just [ ante :|=: p : delete prop succ
             , ante :|=: q : delete prop succ ]

notL :: Rule
notL (ante :|=: succ)
  | not $ any isNot ante = Nothing
  | otherwise = r . fromJust $ find isNot ante
    where
      r prop@(Not p) = Just [ delete prop ante :|=: succ ++ [p] ]

notR :: Rule
notR (ante :|=: succ)
  | not $ any isNot succ = Nothing
  | otherwise = r . fromJust $ find isNot succ
    where
      r prop@(Not q) = Just [ [q] ++ ante :|=: delete prop succ ]

immediate :: Rule
immediate (ante :|=: succ)
  | any (`elem` succ) ante = Just []
  | otherwise = Nothing

-------------- optional

implL :: Rule
implL (ante :|=: succ)
  | not $ any isImpl ante = Nothing
  | otherwise = r . fromJust $ find isImpl ante
    where
      r prop@(p :->: q) = Just [ delete prop ante :|=: [p] ++ succ
                               , delete prop ante ++ [q] :|=: succ ]

implR :: Rule
implR (ante :|=: succ)
  | not $ any isImpl succ = Nothing
  | otherwise = r . fromJust $ find isImpl succ
    where
      r prop@(p :->: q) = Just [ ante ++ [p] :|=: [q] ++ delete prop succ ]

bimpL :: Rule
bimpL (ante :|=: succ)
  | not $ any isBimp ante = Nothing
  | otherwise = r . fromJust $ find isBimp ante
    where
      r prop@(p :<->: q) = Just [ delete prop ante ++ [(p :->: q), (q :->: p)] :|=: succ ]

bimpR :: Rule
bimpR (ante :|=: succ)
  | not $ any isBimp succ = Nothing
  | otherwise = r . fromJust $ find isBimp succ
    where
      r prop@(p :<->: q) = Just [ ante :|=: [(p :->: q)] ++ delete prop succ
                                , ante :|=: [(q :->: p)] ++ delete prop succ ]

-------------- solver
simple :: Prop -> Bool
simple (Not p) = False
simple (p :&&: q) = False
simple (p :||: q) = False
simple (p :->: q) = False
simple (p :<->: q) = False
simple _ = True

flatten :: Sequent -> Sequent
flatten (ante :|=: succ) = nub ante :|=: nub succ

prove :: Sequent -> [Sequent]
prove seq = nub $ p seq
  where
    p :: Sequent -> [Sequent]
    p seq@(ante :|=: succ)
      | isJust (immediate seq) = []
      | and $ map simple (ante ++ succ) = [seq]
      | otherwise = concatMap p $ simplify rules seq

    simplify :: [(Rule)] -> Sequent -> [Sequent]
    simplify [] seq = [seq]
    simplify (rule:rs) seq
            | (rule seq) == Nothing = simplify rs seq
            | otherwise = map flatten $ fromJust (rule seq)

    rules = [immediate, bimpL, bimpR, implL, implR, andL, orR, orL, andR, notL, notR]

-- for challenge part

proveCount :: Sequent -> ([Sequent],Int)
proveCount = undefined

a = Var "a"
b = Var "b"
c = Var "c"
d = Var "d"
e = Var "e"
f = Var "f"
p2 = ([] :|=: [(Not ((Not a :||: b) :&&: (Not c :||: b))) :||: (Not a :||: c)])

p3 = [(a :->: b)] :|=: [(Not b :->: Not a)]

p4 = [((c :||: d) :->: (d :&&: f)),((a :<->: a) :<->: (b :||: a))] :|=: [((c :<->: b) :<->: (b :->: a)),(Not (b :||: d)),(Not (b :&&: d)),((d :<->: f) :->: (c :||: e))]
