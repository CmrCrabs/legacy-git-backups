#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

= CL Tutorial 8
== Exercise 1
=== Logical Expression:
$ (not a and b) or (a and not b) $

=== Tseytin Transformation
substitutions:
$ w <-> not a   &equiv (not a or not w) and (w or a) \
  x <-> not b   &equiv (not b or not x) and (x or b)\
  y <-> w and b &equiv (w or not y) and (b or not y) and ( y or not w or not b )  \
  z <-> a and x &equiv (not z and a) and (not z or x) and ( z or not a or not x ) \
  r <-> y or z  &equiv (r or not y) and (r or not z) and (not r or y or z) $

conjoining, for $r = 1$ (satisfiable):
$ (not a or not w) and (w or a) 
  &and (not b or not x) and (x or b) \
  &and (w or not y) and (b or not y) and ( y or not w or not b )  \
  &and (not z or a) and (not z or x) and ( z or not a or not x ) \
  &and (1 or not y) and (1 or not z) and (not 1 or y or z) $

simplifying:
$ (not a or not w) and (w or a) 
  &and (not b or not x) and (x or b) \
  &and (w or not y) and (b or not y) and ( y or not w or not b )  \
  &and (not z and a) and (not z or x) and ( z or not a or not x ) \
  &and (y or z) $

#pagebreak()
== Exercise 2
=== Expression:
$ & (E or F) and (not A or B) and C \
  &equiv (not E -> F) and (A -> B) and C $
=== Diagram:
#figure(diagram({
  let (S, E, F, A, B, C, N) = ((0,2), (0,1), (0,0), (1, 1), (1, 0), (1, -1), (1, -2))
  node(S,$0$)
  node(E,$not E$)
  node(F,$F$)
  node(A,$A$)
  node(B,$B$)
  node(C,$1$)
  node(N,$C$)
  edge(S, E, "->")
  edge(E, F, "->")
  edge(F, C, "->")
  edge(S, A, "->")
  edge(A, B, "->")
  edge(B, C, "->")
  edge(C, N, "->")
}))
=== Cuts:
#figure(
  image("./cuts.png", width: 80%, height: 40%, fit: "contain")
)
$ "3 blue + 3 red + 2 green + 1 purple
=> 9 satisfying assignments" $
