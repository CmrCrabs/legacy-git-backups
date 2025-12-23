#import "@preview/cetz:0.4.0"
#import "@preview/cetz-venn:0.1.4"
#import "@preview/curryst:0.5.1": rule, prooftree

#let entails = sym.tack.r.double
= CL Tutorial 5
all line seperators are double lines, i am unaware of how to typeset double lines

== Exercise 1
#figure(
  cetz.canvas({
    cetz-venn.venn2(name: "v1")
    import cetz.draw: *
    content("v1.a", [*A*])
    content("v1.b", [*C*])
    content("v1.ab", [_x_])
  }),
  caption: $a entails.not not c$
)
#figure(
  cetz.canvas({
    cetz-venn.venn2(
      name: "v",
      ab-fill: gray,
    )
    import cetz.draw: *
    content("v.a", [*B*])
    content("v.b", [*C*])
  }),
  caption: $b entails not c$
)
#figure(
  cetz.canvas({
    cetz-venn.venn2(
      name: "v",
    )
    import cetz.draw: *
    content("v.a", [*A*   _x_])
    content("v.b", [*B*])
  }),
  caption: $a entails.not b$
)
$ therefore 
  (a entails.not not c wide b entails not c) / (a entails.not b) \
  equiv ( b entails not c wide a entails.not not c) / (a entails.not b) \
  equiv "celantes" $

#pagebreak()
== Exercise 2
$ (a entails b wide b entails c) / (a entails c) &equiv (a entails not b wide not b entails c) / (a entails c) & "variable swap"\
  &equiv (a entails not b wide not b entails not c) / (a entails not c) & "variable swap"\
  &equiv (a entails not b wide not not c entails not not b) / (a entails not c) & "contrapone sequent"\
  &equiv (a entails not b wide c entails b) / (a entails not c) & "double negation"\
  &equiv (a entails not b wide a entails.not not c) / (c entails.not b) & "contrapone rules" $

== Exercise 3
#figure(
  prooftree(
    rule(
      $entails (p and q) or not p or not q$,
      name: $or R, or R$,
      rule(
        $entails p and q, not p, not q$,
        name: $not R, not R$,
        rule(
          $p, q entails p and q$,
          name: $and L$,
          rule(
            $p and q entails p and q$,
            name: $I$,
          )
        )
      )
    )
  )
)

== Exercise 4
#figure(
  [
    #prooftree(
      rule(
        $Gamma, p -> q entails Delta$,
        name: "def",
        rule(
          $Gamma, q or not p entails, Delta$,
          name: $or L$,
          rule(
            $Gamma, q entails Delta$,
            name: $I$,
          ),
          rule(
            $Gamma, not p entails Delta$,
            name: $not L$,
            rule(
              $Gamma entails p, Delta$,
              name: $I$
            )
          )
        )
      )
    )
    $therefore$
    #prooftree(
      rule(
        $Gamma, p -> q entails Delta$,
        name: $->L$,
        $Gamma, q entails Delta$,
        $Gamma entails p, Delta$,
      )
    )
  ],
  caption: $not L$,
)
\
\
#figure(
  [
    #prooftree(
      rule(
        $Gamma entails p -> q, Delta$,
        name: "def",
        rule(
          $Gamma entails q or not p, Delta$,
          name: $or R$,
          rule(
            $Gamma entails q, not p, Delta$,
            name: $not R$,
            $Gamma, p entails q, Delta$
          )
        )
      )
    )
    $therefore$
    #prooftree(
      rule(
        $gamma, entails p -> q, Delta$,
        name: $->R$,
        rule(
          $Gamma, p entails q, Delta$
        )
      )
    )
  ],
  caption: $not R$
)

