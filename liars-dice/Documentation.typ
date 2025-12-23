#set par(justify: true)
#show link: underline
#set page(numbering: "1", margin: 2cm)
#set text(hyphenate: false)
#set heading(numbering: "1.")
#set text(12pt)
#page(numbering: none, [
  #v(2fr)
  #align(center, [
    #image("./dice.png", width: 60%)
    #text(26pt, weight: 700, [Liars Dice])
    #v(0.1fr)
    #text(16pt, [Zayaan Azam])
    #v(0.1fr)
  ])
  #v(2fr)
])


#page(outline(indent: true))

#pagebreak()
= Premise
Five dice per player are used alongside dice cups for concealment.
Players take turns rolling a "hand" of dice under their cups and make a bid based on their observation.

A bid involves a player announcing a chosen face value and the number of dice they belive show that value.

Players can either raise the bid or challenge the previous bid during their turn. 
Raising the bid involves increasing the quantity of dice with a specified face value.

If challenged, all dice are revealed. 
If the bid is valid, the bidder wins;; otherwise, the challenger wins. 

The loser of a round loses one die, and the game continues until only one player retains a die or dice, declaring them the winner. 
The loser of the previous round initiates bidding for the next round, or the next player does so if the previous loser is eliminated.

As Per #link("https://en.wikipedia.org/wiki/Liar%27s_dice", [Wikipedia])

#pagebreak()
= Project Objectives


1. **Program**.
     #linebreak()   1.1 `Main` - Entry point of the application. Calls `Menu.ShowMenu()` to display the main menu.

2. **Constants**
      #linebreak()  2.1 `InstructionsPath` - Constant string defining the path to the instructions file.

3. **Dice**
   #linebreak()     3.1 `value` - Public variable representing the current value of the dice.
    #linebreak()    3.2 `Dice` - Constructor initializing the dice value.
    #linebreak()    3.3 `Roll` - Method to roll the dice and return a random value.

4. **Menu**
      #linebreak()  4.1 `ShowMenu` - Method displaying the main menu and handling user choices.
     #linebreak()   4.2 `ReadInstructions` - Method to display game instructions.
        
5. **Pirate**
   #linebreak()     5.1 `Cup` - Public list of dice representing the pirate's cup.
   #linebreak()     5.2 `Pirate` - Constructor initializing the pirate's cup.
   #linebreak()     5.3 `Roll` - Method to roll the dice in the cup.
   #linebreak()     5.4 `DisplayDice` - Method to display the values of dice in the cup.
   #linebreak()     5.5 `RaiseBid` - Abstract method for raising a bid, to be implemented by subclasses.
    
6. **Player**
   #linebreak() 6.1 **Player**
      #linebreak()  6.1 `RaiseBid` - Overrides `RaiseBid` method from `Pirate` to get bid input from the player.

7. **Computer**
  #linebreak()  7.1 **Computer**
    #linebreak()    7.1 `RaiseBid` - Overrides `RaiseBid` method from `Pirate` to generate a random bid for the computer player.

8. **Table**
  #linebreak()      9.1 `bid` - Public variable representing the current bid.
   #linebreak()     9.2 `player` - Public variable representing the player object.
    #linebreak()    9.3 `computer` - Public variable representing the computer player object.
    #linebreak()     9.4 `Table` - Constructor initializing the table.
   #linebreak()      9.5 `GameLoop` - Method controlling the game flow.
  #linebreak()       9.6 `CallLiar` - Method to handle when a player calls liar.
   #linebreak()      9.7 `OutputBid` - Method to output the current bid values.

#pagebreak()
= Documented Design
document split into 4 files.

== Program.cs 
intiialises the program and holds a few smaller classes.

== Menu.cs 
main menu screen, displays instructions.

== Pirate.cs 
holds the abstract class used to create the player and computer. also holds logic for each thingamajig.

== Table.cs
holds the game logic itself.



#pagebreak()
= Technical Solution 
seen on #link("https://github.com/cmrcrabs/liars-dice", [Github])


#pagebreak()
= Testing

The program works and doesnt break
it handles inputs
below are some screenshots with evidence.

#figure(
image("/Tests/menuoutput.png", width: 100%),
  caption: [
      Menu being outputted
  ],
)

#figure(
image("/Tests/instructionsoutput.png", width: 100%),
  caption: [
      showcase of a submenu with the instructions being outputted
  ],
)

#figure(
image("/Tests/roll_output.png", width: 100%),
  caption: [
the output of a roll
  ],
)
#figure(
image("/Tests/badinput.png", width: 100%),
  caption: [
error handling in case of a bad input
  ],
)
#figure(
image("/Tests/liarcalled.png", width: 100%),
  caption: [
  showcase of what occurs when a liar is called
  ],
)


#pagebreak()
= Evaluation

it works which is good.
it addresses all project objectives

it could work better.

it handles major edge cases.

it could handle minor edge cases.

it could allow for more players / computers.

it could allow for a configuration via the menu instead of Constants.

more data could be shifted into the constants and then used

= Bonus

#figure(
image("/coolshader.png", width: 100%),
  caption: [
    cool fur shader #link("https://github.com/cmrcrabs/fur-shader", [github])
  ],
)
