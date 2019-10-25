# Ogetarts (Stratego)
## Jake Mittleman & Jon Anton
## 10/24/19

    The game that we decided to create is Ogetarts. Ogetarts is a
very close interpretation of the game Stratego, and we were able to implement
almost all of the original game's functionality in the time allotted.
Initially, the user is brought to the index page. Here, the user is prompted
to enter a user name, and a game name. Upon entering a user name and game name,
the user is brought to an existing game if the game exists, or a new game is
started if the game name does not exist. When a second player joins the
existing game, the two players can begin playing the game. If more than
two players join the game, for example a third and fourth player, those
extra players are allowed to view the game, chat with all players in the
channel, and have all changes broadcasted to their socket. However,
these extra players are not allowed to interact with the game in any way,
they cannot influence the game state.

    The game is played on a 10 by 10 board. Each player has 40 total pieces,
and the pieces are distributed as such: 1 flag (rank 12), 6 bombs (rank 11),
1 Marshall (rank 10), 1 General (rank 9), 2 Colonel (rank 8),
3 Major (rank 7), 4 Captain (rank 6), 4 Lieutenant (rank 5), 4 Sergeant
(rank 4), 5 Miner (rank 3), 8 Scout (rank 2), 1 spy (rank 1). Certain
pieces have special abilities. The flag cannot be moved once placed, and if
a flag is captured by the enemy team, this ends the game. Bombs cannot be
moved, and if a bomb is attacked by any rank other than a miner (rank 3),
the attacking piece is killed. The scout can move any number of spaces
horizontally or vertically, as space allows (you cannot jump over pieces).
The spy, if it attacks a Marshall, can defeat a Marshall.

    There are a few more necessary pieces of information in order to begin
playing the game. There are two game ending scenarios: either a player's flag is
successfully attacked by the enemy team, or one player has all of their
piece's captured. Legal moves are defined as such: any piece, with the
exception of bombs and flags, can be selected and moved horizontally or
vertically one space, except for a scout, which can move any number of spaces.
A piece cannot move or attack vertically. A player cannot move onto their own
piece, a player cannot jump over pieces, and if a player moves onto another
player's piece, an attack scenario is initiated. An attack scenario will
progress based on the conditions placed on how pieces of different ranks
interact (briefly described previously, and I will go into more detail on
this in a later paragraph).

    There is a text box at the bottom of the screen, below the board.
When entering text, and selecting the "enter" key, the message is posted
above the text box, and is broadcasted to every user in the game channel.
Any reasonable number of players can join the game channel and chat, and will
receive all broadcasts and updates, however any players beyond the first two
are not allowed to play the game. To the right of the board, we have two
areas which display all of the captured pieces belonging to each player. When
a player's piece is captured, we add it to the area on the side of the board.

    We used mainly react and Konva to render the UI. In our render method we
created a stage with a single layer. In that layer it calls functions that
create the grid first, then each square in the grid. To place the pieces,
Javascript iterates over the given board state and based on information stored
in each "piece" in the state (A piece is an array with the following
information: [id, rank, player, row, column, revealed]) The color is defined
by player and the ranks are shown if the rank is not 0 (otherwise it's blank).
A rank of 0 is a "signal" rank, sent by the server when the individual
user's board is built. In Ogetarts, each player is only allowed to see their
own pieces, unless the opposing player's piece is revealed via attacking at
some point during the game. In order to build individual game board states,
the server will attribute a rank of 0 to each piece that a player is not
allowed to know, and Javascript will render a blank square for each 0.
The actions taken by the player send click information to the server and when
the state is set, the UI gets re-rendered to display information changes like
 pieces being moved or captured/killed.

	To send information from the UI to the server, we use a Phoenix Channel
to handle push messages from the UI which calls server functions and replies
with information back to the state. If we need to push state changes to every
player in the game, we broadcast to each user. For messages we create a
channel.on function so that it broadcasts the same thing to each user.
The channel.on is used because every user can see the message, we don't need
specific information per user. For state changes, we have a handle_out
function to push the state to each user because each user needs a different
state (because stratego pieces need to be hidden for certain players). We also
use a GenServer in addition to a BackupAgent for retrieving games that have
already started and dealing with server-side interactions. The backup agent
and GenServer allow players to rejoin and recover the game they were playing
if, for example, they close their browser tab and re-enter the same game name.
Even if a user quits, another user cannot join and take their place, as that
new user will not be included in the players list. Also, we restrict the number
of "players" to 2 players (so the third player in and any subsequent
player won't be able to make board moves, but can still chat.)

    We maintain a number of data structures on the server in order to play
the game. The state contains: a board array, a last click, player 1's
remaining piece count, player 2's remaining piece count, player 1's captured
pieces, player 2's captured pieces, a flag found boolean, and an array
of players. The board is an array of 10 nested array, one for each row, and in
each row array there are 10 piece arrays, one for each piece in the row. A
piece is represented by an array of 6 elements: id, rank, player number,
i, j, and revealed. In order to properly interpret moving and attacking logic,
when a piece is selected, we add it to the last_click. We maintain a counter
to track the remaining moveable pieces each player has in order to implement
game over logic when a player is out of moves. We also maintain lists for
each player to track their captured pieces, and display them on the side of
the board. We use a boolean flag found that is initialized to false, and is
set to true if a player's flag is attacked. Finally, we maintain a list of
active players, which is initialized to empty, and as users join the game,
they are added to the players list. Only the first two players are added to
the list, as they are the only ones allowed to play the game.  

    All of the game rules are implemented on the server. The most crucial
game logic is moving pieces. In our move_piece function, we first prevent a
user from being able to select an opponent's piece. If we check there is no
last_click and there is no previously selected piece, a player's piece can be
selected, and a valid square can be subsequently selected. A legal move is
reasoned as such in our is_legal_move logic: you cannot move onto your own
pieces, movement must be horizontal or vertical, and you can only move one
square at a time. We also must call separate logic for a scout, in the
checkScoutLegaLMove function, as the scout is the only piece that can move
more than one square at a time.

    If we are moving the piece to a blank spot, we only need to delete the
piece from the row we are moving from, and add the piece to the row we are
moving to. If the spot we are moving to contains an opponent piece, we
need to run our attack logic. There are several scenarios, based on the
rank of both the attacking and attacked piece. If the attacked piece is a
flag, the game is over. If a bomb is attacked by a miner, the bomb is killed,
and the miner is moved to the bomb's spot. If a bomb is attacked by anyone else,
the attacking piece is killed, and the attacking piece is deleted. If
a Marshall is attacked by a spy, the Marshall is killed, and the spy is moved
to the Marshall's spot. If the attacking and attacked piece are both equal rank,
they are both killed, and both deleted from the board. Apart from these
scenarios, we only need to consider which piece has a higher rank. The piece
with the higher rank wins, and the piece with the lower rank is killed and
removed from the board. If an end game scenario is encountered, we alert the
users that a player has won the game, and we call a reset_game function
to begin a new game.

    We faced a number of challenges throughout the design and engineering
of this game. Since the game of Ogetarts dictates that each player can only
see their own pieces, or opponent's pieces previously revealed via attacking,
we needed to send separate game states to each player. We solved this
problem with an intercept "update" and a handle_out function in the
Game Channel. With the handle out call, we are able to intercept any board
updates that need to be done, and pass the user along to the client_view
function. Once we have the user, we map over the board in the build_skel
function and check if the user matches the player of the piece. If it does,
we can reveal the piece. Otherwise, we send the client that same piece,
but with the rank set to "0" instead of the actual rank. Then, in the
javascript, we can render pieces with rank 0 as a blank Rect, so that the user
cannot see the rank of those pieces.   

    Another challenge we faced was updating the board. Due to assigned
variables being immutable in elixir, we struggled at first to correctly update
the board when moving a piece or attacking another piece.   
