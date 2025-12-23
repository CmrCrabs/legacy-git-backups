#set par(justify: true)
#show link: underline
#set page(numbering: "1", margin: 2cm)
#set text(hyphenate: false)
#set heading(numbering: "1.")
#set text(12pt)
#page(numbering: none, [
  #v(2fr)
  #align(center, [
    #image("/Assets/Paperboat.svg", width: 60%)
    #text(26pt, weight: 700, [Battleboats])
    #v(0.1fr)
    #text(16pt, [Zayaan Azam])
  ])
  #v(2fr)
])


#page(outline(indent: true))
= Project Objectives
1. Create A Menu that allows the User to start a new game, load a pre-existing game, read the instructions or exit. 
2. The program will validate and ensure that the inputs do correspond to a existing option and will capture the keypress, not the input itself.
3. Upon the 'New Game' option being selected, the user should be prompted to place an amount of boats (with a specified rotation) on a grid of size that is specified in the Constants.cs file. 
4. The boats will be validated in order to ensure they do not get placed over each other, do not exceed the bounds of the grid and, have a valid rotation.
5. The program will, alongside the player, create a 'FleetMap' for the player that is used for computational purposes.
6. The program will then go on to generate the fleet for the computer following the same restrictions as the players boats.
7. The program will similarly create a 'FleetMap' for the computer that is used for the same purposes.
8. The program will then start the turn cycle, beginning with the player turn. 
9. for each turn cycle, the player will choose a position to target.
10. said target is validated to ensure that it has not been used before.
11. this target will then be checked for, successively, a Hit > Sink > Victory.
12. The computer will then take their turn, performing the same targeting and checking cycle as the player.
13. The players grid will then be output to the player, showing the results of the computers turn.
14. this process will then be repeated until either victory is achieved for either person, where the game will end, or until escape is pressed.
15. At any point during the game loop, if the player were to press 'Escape', the game will save to disk and then display a in-game Menu
16. this menu will allow the player to either continue the game, read the instructions or save and exit the game.
17. as in the main menu, if the instructions option is selected the program will display the "Instructions.txt" file located in ./Documentation/ to the player 
18. the player may then exit the instructions by pressing escape, returning to the menu.
19. the game will be able to be controlled via either the arrow, or WASD Keys, as detailed in the instructions
#pagebreak()
= Planning
#figure(
image("/Assets/mockup.png", width: 35%),
  caption: [
    Initial Mockup
  ],
)
#pagebreak()
= Documented Design

== Function Heirarchy
#figure(
image("/Assets/heirarchy.svg", width: 120%),
  caption: [
    Software Heirarchy, In order of src > files > classes > functions. Better view can be seen in ./Documentation/Assets/heirarchy.svg
  ],
)

#pagebreak()
== Configurable Parameters (Constants)
There are a few configurable parameters that will globally change the way the game will function. these consist of the following:
- width: the width of the playable game space
- height: the height of the playable game space
- window width: the width of the terminal, used for visual purposes, only works on windows
- window height: the height of the terminal, used for visual purposes, only works on windows
- Fleet: a list of the struct boat, used to determine whats boats are placeable for the player / computer. these can be changed and will work throughout the program, and is defined by the quantity of each boat, and the total length of said boat.
== Data Structures
Tile: an enumerable, used primarily for rendering / logical purposes in order to better store the map data. Consists of the following:
- Empty1 & Empty2: logically the same, used for denoting that the cell is empty. The reasoning for 2 is to create the slight visual effect of a wave, by having a light and dark colour for the wave.
- Boat: used to denote where a boat has been placed 
- Wreckage: replaces a boat, when the individual boat has been entirely hit 
- Hit: Where a boat has been hit by a shot 
- Miss: where a shot has missed any boats 
- Using: no technical purpose, used to visually show what cell is currently being occupied by the 'cursor'


Boat:
- a struct used in the <Fleet>, that stores the quantity and length of each individual boat. This is used to determine what boats can be placed and the size of them.

BoatMap:
-  a struct used in the <FleetMap>, that stores, for each boat, the seed coordinate, length, rotation, and sunk status. 
- This is used primarily to determine whether a boat is either sunk or if victory has been achieved.

Data:
- a class, that holds all data that would be needed to start a new game. 
- this is done for easier parameter calling and function passing, whilst also being useful for the saving and loading, due to the way newtonsoft serialises json.

Captain:
- an abstract class, used to create a form of 'template' that is then further used to create both the player and computer implementations. 
- An abstract class is useful as it allows you to define abstract functions; ie functions that are just declared and not initialised. it also allows you define shared private functions, that can only be accessible by classes that inherit this abstract.

#pagebreak()
== Imports

Newtonsoft.json:
used for elegant serialisation and deserialisation. It allows you to convert even custom types into json compared to systems solution 

== Saving / Loading

Done via newtonsoft.json. instead of manually creating my own formatting for saving and loading it is done through standard json syntax. All required data is put into the Data class earlier in the program and upon serialisation, it is only that class that is saved to the file (that is specified in Constants.cs).

#pagebreak()
= Technical Solution

== Foreword
The C\# Code & All Documentation can be accessed at the #link("https://github.com/cmrcrabs/battle-boats", [Git Repo]) and further is attached in a zip file to the teams assignment. Below listed is each file with its commented code and, a brief explanation on the purpose of the file. Note that there exists a somewhat extensive version control history, however due to an incident involving a lack of patience and \-\-force, the history is cut off abruptly around the time of a somewhat major rewrite. The code is not copied here as that would add an additional 18 pages to this document for no real benefit, as it would be a better experience to read the code through your preferred IDE. (vim).

== Files
=== Program.cs
Compiler entry point, Initialises code and provides disclaimer depending on OS.
```cs 
```

=== Menu.cs
Allows player to decide what they wish to do and learn rules of the game. 
```cs 
```
=== Constants.cs
Serves as the 'settings' for the game, also declares key types used throughout the project.
```cs 
```
=== Abstracts.cs
Creates an abstract class implementation that is then used in Player.cs & Computer.cs
```cs 
```

=== Persistence.cs
Provides saving and loading functionality using json
```cs 
```

=== Display.cs
Frontend for the project, outputs results of the other files
```cs 
```

=== Game.cs
Provides the game initialisation and loop.
```cs 
```

=== Player.cs
Players implementation of the Captain abstract.
```cs 
```

=== Computer.cs
Computers implementation of the Captain abstract.
```cs 
```

#pagebreak()
= Testing
== Foreword
All testing is completed on Arch Linux, with an up to date set of kernel packages. it is completed on the kitty terminal emulator and is done using the default base16 colour scheme. the terminal font is monospace and should not affect testing. There is only 1 piece of code that should operate differently per platform and that has been validated by an external party.

== Menu
#figure(
image("/Tests/menu-output.png", width: 35%),
  caption: [
    Menu Outputting correctly and not reacting to invalid inputs
  ],
)
#figure(
image("/Tests/instructions.png", width: 100%),
  caption: [
    Instructions
  ],
)
#figure(
image("/Tests/exiting.png", width: 50%),
  caption: [
    Exiting, can be seen returning to shell with no errors
  ],
)

#pagebreak()
== Rendering
#figure(
image("/Tests/output.png", width: 60%),
  caption: [
    Displaying Key & Grid
  ],
)
#figure(
image("/Tests/colours.png", width: 20%),
  caption: [
    Example with all possible colours being displayed
  ],
)
#figure(
image("/Tests/computers-turn.png", width: 100%),
  caption: [
    Showcase Of Results of Computers Turn
  ],
)

#pagebreak()
== Inputs
#figure(
image("/Tests/menu-output.png", width: 35%),
  caption: [
    Extraneous Inputs Not Doing Anything, (Difficult to show via image)
  ],
)

== Targeting
#figure(
image("/Tests/invalid-target.png", width: 50%),
  caption: [
    Validation of if target is valid, can be seen by message. Note that the highlighted cell is a miss (is clearly known when actually playing)
  ],
)
#figure(
image("/Tests/targeting-options.png", width: 50%),
  caption: [
    Target Hit, Miss & Wreckage (Sunk)
  ],
)

#pagebreak()
== Placing
#figure(
image("/Tests/invalid-placement.png", width: 70%),
  caption: [
    Overlap Detection, shown in message
  ],
)
#figure(
image("/Tests/placements.png", width: 70%),
  caption: [
    Differing Sizes & Rotation
  ],
)

#pagebreak()
== Persistence
#figure(
image("/Tests/saved.png", width: 120%),
  caption: [
    Saving the game via menu & outputted savefile
  ],
)
#figure(
image("/Tests/loading.png", width: 100%),
  caption: [
    Loading, below save file corresponds to this game which can be observed if read
  ],
)
#figure(
block(fill: luma(230), inset: 8pt, radius: 4pt, width: 100%, raw(read("Tests/savegame.json"))),
  caption: [
    Save File Itself
  ],
)


#pagebreak()
= Evaluation

Overall I think my project has solidly met or exceeded the points stated in Objectives. I also believe I completed the extensions outlined in the briefing. 
Throughout the development of the project there were no major problems that needed solving, with the primary issue I ran into being rendering the player 'cursor' in real time.
If given the chance to do the project again, I would consider redo-ing / improving upon the following things:
  - Advancing the computers targeting AI, such as making it consider the previous shots and whether they were hit and misses, or even placing the boats in a more 'strategic' way, potentially with preset patterns.
  - Create a nicer, more detailed User Interface 
  - Create a inbuilt method to adjust the 'Settings' (the constants), so that the user can better adjust the gameplay to suit them.
  - create a scaling UI, as, whilst all the technical parts 100% scale correctly, some of the visual flair does not.
  - Optimisation of some particularly egregious 1 liners, primarily in some if statements.
