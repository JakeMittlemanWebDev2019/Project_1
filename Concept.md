# Stratego Concept
## Jake Mittleman & Jon Anton

### About the Game
 The game we are going to build is Stratego (Oget Arts, as a generic version).
 The game is played on a 10 by 10 board, with 40 pieces per player.
 The pieces consist of 33 members of an army, 6 bombs, and 1 flag. This is
 strictly a 2 player game. Before the game starts, each player chooses the
 location of each piece. Pieces can be moved forward, backward, left, or right.
 Each piece has a rank, and can attack other pieces. The rank determines which
 pieces wins the exchange with some special circumstances.
 The game ends when either all of a player's pieces have been captured, or a
 player captures the opposing player's flag.

### Game specifications
The game of Oget Arts is well specified, but we need to make a few
changes so the game will be generic. We've changed the name and we are not going
to use any of the original art, or names of ranked pieces, bombs, or flags.
The rules and win conditions are clear and specified as well. Piece movement
is restricted to horizontal or vertical, win conditions are simple and clear,
and the game logic is complicated enough to be suitable, but not trivial.

### Iterative Development
There is some functionality that we plan to implement as part of "core"
functionality vs. "nice to have" functionality. First iteration, we plan
to automate the board setup and piece placement, so that we can focus on
implementing game logic. We will start with a smaller version, 6 by 6 board,
and once type of piece each, totaling 12 pieces per player.

Second iteration, we think it's relatively necessary to offer a landing page
for the players to set up their own pieces before starting the game, and we
should have time to implement this. Also, we want to then implement a 10 by
10 board, with the accurate amount of pieces per the actual game rules.

Third iteration, there are a number of nice to have features: implementing
lakes in the middle of the board, showing chat history instead of single
messages, graphics on the pieces vs. plain numbers, better animations for
dragging and dropping pieces. We believe we will have time for at least
most of these.

### Expected Challenges
We expect that it will be difficult to allow players to set up their own pieces.
We are not sure exactly what this will entail, but we envision a landing page
where the player is taken to do setup, and then can begin the game once both
players are finished. We also might want to offer a few different board size
and piece number options to the player so they can choose their own game.

We also anticipate it being difficult to show individual game states, since
the rules dictate that a player is not allowed to see the other player's pieces.
