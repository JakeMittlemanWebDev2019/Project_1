defmodule Ogetarts.Game do
    #TODO: show piece that gets attacked
    #TODO: implementing water in middle
    #TODO: there are a few "draw" scenarios, but they aren't technically in the game rules
    #TODO: show pieces that have been taken from the board

    def new() do
    %{
        board: build_board(),
        last_click: [],
        p1_piece_count: 33,
        p2_piece_count: 33,
        flag_found: false,
        players: [],
    }
    end

    def client_view(game, user) do
      player1 = Enum.at(game.players,0)
      player2 = Enum.at(game.players,1)

    %{
        # array: [id, rank, player]
        board: build_skel(game, player1, player2, user),
        last_click: game.last_click,
        p1_piece_count: game.p1_piece_count,
        p2_piece_count: game.p2_piece_count,
        flag_found: game.flag_found,
        players: game.players,
    }
    end

    def build_skel(game, player1, player2, user) do
      IO.puts(player1)
      IO.puts(player2)
      IO.puts(user)
      if (user == player1) do
        Enum.map(game.board, fn row ->
          Enum.map(row, fn piece ->
              if (Enum.at(piece, 2) == 1) do
                piece
              else
                if (Enum.at(piece, 5)) do
                  piece
                else
                  # set rank to 0
                  List.replace_at(piece, 1, 0)
                end
              end
          end)
        end)
      else
        Enum.map(game.board, fn row ->
          Enum.map(row, fn piece ->
              if (Enum.at(piece, 2) == 2) do
                piece
              else
                if (Enum.at(piece, 5)) do
                  piece
                else
                  # set rank to 0
                  List.replace_at(piece, 1, 0)
                end
              end
          end)
        end)
      end
    end

    def reset_game do
        new()
    end

    # Changed this to not use map_reduce because we have List.replace_at()
    def change_board_row(game, board, row, new_data, i, j) do

      if (length(new_data) != 0) do
        # If we're not removing a piece
        # we have to update its i and j
        new_piece = new_data
        |> List.replace_at(3, i)
        |> List.replace_at(4, j)

        # put new piece in new row
        new_row = List.replace_at(row, j, new_piece)

        List.replace_at(board, i, new_row)
      else
        # put new piece in new row
        new_row = List.replace_at(row, j, new_data)

        List.replace_at(board, i, new_row)
      end
    end

  # If the Attacking Piece wins, we put attacker in attacked slot
  # and make the old attacker's slot []
  # update_counts is a boolean and if it's true we update counts
  # if it's false, we don't. Player is the player to update counts
  # for
  def resolve_attacker_wins(game, attacking_piece, attacked_piece,
                    update_counts, player) do

    old_i = Enum.at(attacking_piece, 3)
    old_j = Enum.at(attacking_piece, 4)
    new_i = Enum.at(attacked_piece, 3)
    new_j = Enum.at(attacked_piece, 4)

    board = game.board
    insert_row = Enum.at(board, new_i)

    piece = game.last_click
    piece = List.replace_at(piece, 5, true)

    # board = change_board_row(game, board, insert_row,
    #                         game.last_click, new_i, new_j)

    board = change_board_row(game, board, insert_row,
                             piece, new_i, new_j)

    delete_row = Enum.at(board, old_i)
    board = change_board_row(game, board, delete_row,
                            [], old_i, old_j)

    if (update_counts) do
      if (player == 1) do
        Map.merge(game, %{last_click: [], board: board,
                          p1_piece_count: (game.p1_piece_count - 1)})
      else
        Map.merge(game, %{last_click: [], board: board,
                          p2_piece_count: (game.p2_piece_count - 1)})
      end
    else
      Map.merge(game, %{last_click: [], board: board})
    end
  end

  # If the defending piece wins, we remove the attacker form the board
  # since flags and bombs can't attack we always decrement piece count
  def resolve_attacked_wins(game, attacking_piece, attacked_piece, player) do

    i = Enum.at(attacking_piece, 3)
    j = Enum.at(attacking_piece, 4)

    new_piece = List.replace_at(attacked_piece, 5, true)

    board = change_board_row(game, game.board, Enum.at(game.board, Enum.at(new_piece, 3)),
                            new_piece, Enum.at(new_piece,3), Enum.at(new_piece,4))


    board = change_board_row(game, board, Enum.at(board, i), [], i, j)

    if (player == 1) do
      Map.merge(game, %{last_click: [], board: board,
                        p1_piece_count: (game.p1_piece_count - 1)})
    else
      Map.merge(game, %{last_click: [], board: board,
                        p2_piece_count: (game.p2_piece_count - 1)})
    end

  end

  def attack(game, attacked_piece) do
      attacking_piece = game.last_click
      attacking_piece_rank = Enum.at(attacking_piece,1)
      attacking_piece_player = Enum.at(attacking_piece, 2)

      attacked_piece_rank = Enum.at(attacked_piece, 1)
      attacked_piece_player = Enum.at(attacked_piece, 2)

      cond do
          # flag is attacked
          attacked_piece_rank == 12 ->
              #TODO
              # set flag_found, send alert, end game

             game = Map.merge(game, %{
                                flag_found: true
                                })
             game



          # bomb is attacked by miner
          (attacked_piece_rank == 11) && (attacking_piece_rank == 3) ->
              resolve_attacker_wins(game, attacking_piece,
                                    attacked_piece, false, 0)


          # bomb is attacked by non-miner
          (attacked_piece_rank == 11) && (attacking_piece_rank != 3) ->
              if (attacking_piece_player == 1) do
                resolve_attacked_wins(game, attacking_piece, attacked_piece, 1)
              else
                resolve_attacked_wins(game, attacking_piece, attacked_piece, 2)
              end

          # marhsall attacked by spy
          (attacked_piece_rank == 10) && (attacking_piece_rank == 1) ->
              if (attacked_piece_player == 1) do
                resolve_attacker_wins(game, attacking_piece,
                                      attacked_piece, true, 1)
              else
                resolve_attacker_wins(game, attacking_piece,
                                      attacked_piece, true, 2)
              end

          # pieces of equal rank kill each other
          (attacked_piece_rank == attacking_piece_rank) ->
              attacker_i = Enum.at(attacking_piece, 3)
              attacker_j = Enum.at(attacking_piece, 4)
              defender_i = Enum.at(attacked_piece, 3)
              defender_j = Enum.at(attacked_piece, 4)
              board = game.board

              new_attacker_row = Enum.at(board, attacker_i)
              new_defender_row = Enum.at(board, defender_i)

              board = change_board_row(game, board, new_attacker_row, [],
                                attacker_i, attacker_j)

              board = change_board_row(game, board, new_defender_row, [],
                                defender_i, defender_j)

              Map.merge(game, %{last_click: [], board: board,
                                p2_piece_count: (game.p2_piece_count - 1),
                                p1_piece_count: (game.p1_piece_count - 1)})

          # pieces of different ranks
          (attacked_piece_rank != attacking_piece_rank) ->
              if (attacking_piece_rank > attacked_piece_rank) do
                  # remove attacked_piece
                  # decrement attacked_piece_rank's piece count
                  if (attacked_piece_player == 1) do
                    resolve_attacker_wins(game, attacking_piece,
                                          attacked_piece, true, 1)
                  else
                    resolve_attacker_wins(game, attacking_piece,
                                          attacked_piece, true, 2)
                  end
              else
                  # remove attacking_piece
                  # decrement attacking_piece_rank's piece count
                  if (attacking_piece_player == 1) do
                    resolve_attacked_wins(game, attacking_piece, attacked_piece, 1)
                  else
                    resolve_attacked_wins(game, attacking_piece, attacked_piece, 2)
                  end
              end

          # default
          true ->
              true
      end
  end

  # this function assumes that the i,j positions passed to it
  # are legal (only horizontal or vertical)
  def checkScoutLegalMove(board, old_i, old_j, new_i, new_j) do
    # since we're going to check each position from where
    # the scout moves to where he finishes, we need to check
    # that the way is cleared and easier to do this with
    # a range from lower num -> higher num

    if (old_i == new_i) do
      from_position = min(old_j, new_j)
      to_position = max(old_j, new_j)

      # this gets the row that the piece is moving in
      # then it slices it + and - 1 (we just need to check
      # if there are pieces in the intermediary positions)
      row = Enum.at(board, old_i)
      movement_range = Enum.slice(row, from_position+1..to_position-1)

      # this immediately returns true if the function
      # returns true. But we want the function to return
      # false if it CAN'T move, so that's why we reverse
      # the result
      canMove = Enum.any?(movement_range, fn piece ->
          piece != []
        end)
      !canMove


    else
      from_position = min(old_i, new_i)
      to_position = max(old_i, new_i)

      column = Enum.map((from_position+1)..(to_position-1), fn index ->
        # (Get the piece (from the row it's in) at j)
        # -> [[],[],[],[],[],[],[],[],[],[]] (get row)
        #         |
        #         v
        #    [[],[],[],[],[],[],[],[],[],[]] (then get the piece)
        Enum.at(Enum.at(board, index), old_j)
      end)

      canMove = Enum.any?(column, fn piece ->
          piece != []
        end)

      !canMove
    end
  end


  def is_legal_move(game, to_spot, i, j) do

    last_i = Enum.at(game.last_click, 3)
    last_j = Enum.at(game.last_click, 4)
    last_rank = Enum.at(game.last_click, 1)
    board = game.board
    # Get the player number, 1 or 2, of the last clicked piece, and next clicked piece
    last_player_piece = Enum.at(game.last_click,2)
    current_player_piece = Enum.at(to_spot,2)

    cond do
        # scout (rank 2) movement is horizontal or vertical, unlimited spaces
        (last_rank == 2) && ((last_i == i) || (last_j == j)) && last_player_piece != current_player_piece ->
            (if (abs(last_i - i) == 1 || abs(last_j - j) == 1) do
              true
            else
              checkScoutLegalMove(board, last_i, last_j, i, j)
            end)

        ((last_i + 1) == i && (last_j) == j) && last_player_piece != current_player_piece ->
            true
        ((last_i - 1) == i && (last_j) == j) && last_player_piece != current_player_piece ->
            true
        ((last_j + 1) == j && (last_i) == i) && last_player_piece != current_player_piece ->
            true
        ((last_j - 1) == j && (last_i) == i) && last_player_piece != current_player_piece ->
            true

        true ->
            false
    end
  end


  def move_piece(game, user, i, j) do
    row = Enum.at(game.board, i)
    piece = Enum.at(row, j)
    pieces_player = Enum.at(piece, 2)

    player1 = Enum.at(game.players,0)
    player2 = Enum.at(game.players,1)

    if ((user == player1 && (pieces_player == 1 || piece == [] || length(game.last_click) != 0)) ||
        (user == player2 && (pieces_player == 2 || piece == [] || length(game.last_click) != 0))) do

      if (length(game.last_click) == 0) do
          # piece cannot be empty, piece cannot be bomb or flag (rank 11 or 12)
          if ((length(piece) != 0) && Enum.at(piece,1) <=10) do
              Map.put(game, :last_click, piece)
          else
              game
          end

      else
          if (piece == game.last_click) do
            Map.merge(game, %{last_click: []})
          else
            if (is_legal_move(game, piece, i, j)) do

                if (length(piece) != 0) do
                  attack(game, piece)
                else
                  board = game.board
                  # This is the i value in last_click so we don't have to
                  # keep calling Enum.at.
                  # The (i, j) pair passed into the function is for the
                  # insert row.
                  delete_i = Enum.at(game.last_click, 3)
                  # this is the same for j
                  delete_j = Enum.at(game.last_click, 4)

                  insert_row = Enum.at(board, i)

                  # This is the duplicated code, just in a function now
                  # With all the params honestly not sure it's better, but
                  # code at least isn't duplicated now....
                  board = change_board_row(game, board, insert_row, game.last_click, i, j)

                  # very important that this is after we insert.
                  # Otherwise it's taking an old state if you're moving a piece
                  # in the same row.
                  delete_row = Enum.at(board, delete_i)

                  board = change_board_row(game, board, delete_row,
                                          [], delete_i, delete_j)

                  Map.merge(game, %{last_click: [], board: board})
                end
            else
                game
            end
          end
      end
    else
      game
    end
end

  def build_board() do

    p1 = [1, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6,
            7, 7, 7, 8, 8, 9, 10, 11, 11, 11, 11, 11, 11, 12]

    p2 = [1, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6,
            7, 7, 7, 8, 8, 9, 10, 11, 11, 11, 11, 11, 11, 12]

    p1_shuffle = Enum.shuffle(p1)
    p2_shuffle = Enum.shuffle(p2)

    Enum.map(0..9, fn i ->
        Enum.map(0..9, fn j ->
            cond do
                i <= 3 ->
                    [(10*(i+1))-(10-(j+1)), Enum.at(p1_shuffle, (10*(i+1))-(10-(j+1))-1), 1, i, j,
                    false]
                i >= 6 ->
                    [(10*(i+1))-(10-(j+1)), Enum.at(p2_shuffle, 100 - ((10*(i+1))-(10-(j+1))+1)), 2, i, j,
                    false]
                i > 3 && i < 6 ->
                    []
            end
        end)

    end)
  end
end
