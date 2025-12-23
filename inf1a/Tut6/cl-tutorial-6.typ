#import "@preview/truthfy:0.6.0": truth-table, truth-table-empty
#import "@preview/k-mapper:1.2.0": *

= CL Tutorial 6

== Exercise 1
=== a)
#figure(
  karnaugh(
    16,
    x-label: $c d$,
    y-label: $a b$,
    manual-terms: (
      1,0,1,0,
      1,0,1,0,
      0,0,1,1,
      0,0,1,1,
    ),
    implicants: ((1,7),(12,9)),
  )
)

$ equiv (not d and not a) or (a and c) $

=== b)
#figure(
  karnaugh(
    16,
    x-label: $a b$,
    y-label: $c d$,
    manual-terms: (
      1,0,1,0,
      1,0,1,0,
      0,0,1,1,
      0,0,1,1,
    ),
    implicants: ((1,7),(12,9)),
  )
)
$ &equiv not [(d and not a) or (a and not c)] \
  &equiv not (d and not a) and not (a and not c) \
  &equiv (not d or a) and (not a or c) $

#import "@preview/km:0.1.0": karnaugh
== Exercise 2
#figure(
  truth-table($a -> b$, $b or not a$)
)

#figure(
  karnaugh(("r", "ab"),
    implicants: (
      (0, 3, 1, 1),
      (1, 0, 2, 1),
      (1, 1, 2, 1),
    ),
    (
      (0, 0, 0, 1),
      (1, 1, 1, 0),
    ),
    show-zero: true
  )
)
$ equiv (not r and a and not b) or (not a and r) or (b and r) $

==  Exercise 3
#import "@preview/k-mapper:1.2.0": *
=== a)
#figure(
  truth-table($a or not b$, $not a or not d$)
)
#figure(
  karnaugh(
    16,
    x-label: $c d$,
    y-label: $a b$,
    manual-terms: (
      1,1,1,1,
      1,1,0,0,
      0,0,0,0,
      1,1,0,0,
    ),
    implicants: ((8,9),(7,14),(11,10)),
  )
)

=== b)
$ & not [ (not c and a and not b) or (c and a and not b) or (d and b)] \
  &equiv not [ (a and not b) or (b and d)] \
  &equiv not (a and not b) and not (b and d) \
  &equiv (not a or b) and (not b or not d) $

