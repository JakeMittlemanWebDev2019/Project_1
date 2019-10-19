defmodule Ogetarts.Game do
    #TODO: when moving a 2, we need to check if there are pieces in between. 2 should not be able to jump over pieces
    #TODO: attacking logic for ranked pieces
    #TODO: highlight clicked pieces
    #TODO: highlight available moves
    #TODO: implementing water in middle
    #TODO: there are a few "draw" scenarios, but they aren't technically in the game rules

    def new do
    %{
        board: build_board(),
        last_click: [],
        p1_piece_count: 33,
        p2_piece_count: 33,
        flag_found: false,
    }
    end

    def client_view(game) do
    %{
        # array: [id, rank, player]
        board: game.board,
        last_click: game.last_click
    }
    end

    def change_board_row(game, board, row, new_data, i, j) do

    new_row = Enum.map_reduce(row, 0, fn piece, index ->
        if (index == (j)) do
            if (length(new_data) != 0) do
                # If we're not removing a piece
                # we have to update its i and j
                updated_data = List.replace_at(new_data, 3, i)
                updated_data = List.replace_at(updated_data, 4, j)
                {updated_data, index + 1}
            else
                {new_data, index + 1}
            end
        else
            {piece, index + 1}
        end
    end)

    # We're dumb and didn't even look at replace_at.
    # Now we don't have to insert/delete. We just replace.
    # Can't believe we missed that for like 72 hours
    List.replace_at(board, i, elem(new_row,0))
  end



    def attack(game, attacked_piece) do
        #TODO
        # bombs(rank 11) kill everyone except miners(rank 3)
        # attacking flag(rank 12) should set flag_found state variable and end the game
        # marshall(rank 10) can only be killed by spy(rank 1)
        # Decrement p1 or p2 piece count, if necessary
        # pieces of equal rank attacking each other both are killed

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
                true

            # bomb is attacked by miner
            (attacked_piece_rank == 11) && (attacking_piece_rank == 3) ->
                #TODO
                # remove attacked piece from the board
                # DO NOT decrement piece counts
                true

            # bomb is attacked by non-miner
            (attacked_piece_rank == 11) && (attacking_piece_rank != 3) ->
                #TODO
                # remove attacking piece from the board
                # decrement attacking_piece_rank piece count
                true

            # marhsall attacked by spy
            (attacked_piece_rank == 10) && (attacking_piece_rank == 1) ->
                #TODO
                # remove attacked_piece from the board
                # decrement attacked_piece_rank's piece count
                true

            # pieces of equal rank kill each other
            (attacked_piece_rank == attacking_piece_rank) ->
                #TODO
                # remove both pieces from the board
                # decrement both p1 and p2 piece count
                true

            # pieces of different ranks
            (attacked_piece_rank != attacking_piece_rank) ->
                #TODO
                if (attacking_piece_rank > attacked_piece_rank) do
                    # remove attacked_piece
                    # decrement attacked_piece_rank's piece count
                    true
                else
                    # remove attacking_piece
                    # decrement attacking_piece_rank's piece count
                    true
                end

            # default
            true ->
                true
        end




    end



  def is_legal_move(game, piece, i, j) do
    #TODO: when moving a 2, we need to check if there are pieces in between. 2 should not be able to jump over pieces

    last_i = Enum.at(game.last_click, 3)
    last_j = Enum.at(game.last_click, 4)
    last_rank = Enum.at(game.last_click, 1)
    board = game.board
    # Get the player number, 1 or 2, of the last clicked piece, and next clicked piece
    last_player_piece = Enum.at(game.last_click,2)
    current_player_piece = Enum.at(piece,2)

    cond do
        # scout (rank 2) movement is horizontal or vertical, unlimited spaces
        (last_rank == 2) && ((last_i == i) || (last_j == j)) && last_player_piece != current_player_piece ->
            true

        # any piece can move horizontally or vertially once space. Bombs and flags
        # are restricted in move_piece to prevent last_click being set if a player
        # clicks a bomb or a flag
        ((last_i + 1) == i && (last_j) == j) && last_player_piece != current_player_piece ->
            true
        ((last_i - 1) == i && (last_j) == j) && last_player_piece != current_player_piece ->
            true
        ((last_j + 1) == j && (last_i) == i) && last_player_piece != current_player_piece ->
            true
        ((last_j - 1) == j && (last_i) == i) && last_player_piece != current_player_piece ->
            true


        #TODO: we need to be able to deselect a piece we previously
        # selected and added to last_click. If we can't deselect, then we will
        # get stuck if we click on a piece that is surrounded by it's own pieces...

        # This logic isn't quite right, but it's
        # on the right track i think? Currently it's deleting the piece, instead
        # of just clearing out last_click
        game.last_click == piece ->
            Map.merge(game, %{last_click: [], board: board})

        # Cond statements need at least one statement to be truthy. We can't
        # Compile if every statemnt in a cond is false. This true -> false
        # block is a default truthy statement. We now check if is_legal_move
        # returns true in the move_piece function
        true ->
            false
    end
  end


  def move_piece(game, i, j) do
    row = Enum.at(game.board, i)
    piece = Enum.at(row, j)

    if (length(game.last_click) == 0) do
        # piece cannot be empty, piece cannot be bomb or flag (rank 11 or 12)
        if ((length(piece) != 0) && Enum.at(piece,1) <=10) do
            Map.put(game, :last_click, piece)
        else
            game
        end

    else
        if (is_legal_move(game, piece, i, j)) do


            #TODO:
            # We should probably trigger the attack logic here?


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
        else
            game
        end
    end
end

        # This was moved to "change_board_row"

        # new_row = Enum.map_reduce(insert_row, 0, fn piece, index ->
        #     if (index == (j)) do
        #         {game.last_click, index + 1}
        #     else
        #         {piece, index + 1}
        #     end
        # end)
        # board = List.insert_at(board, i, elem(new_row,0))
        # board = List.delete_at(board, i+1)
        #
        #
        # delete_row = Enum.map_reduce(delete_row, 0, fn piece, index ->
        #     if (index == Enum.at(game.last_click, 4)) do
        #         {[], index + 1}
        #     else
        #         {piece, index + 1}
        #     end
        # end)
        #
        # board = List.insert_at(board, Enum.at(game.last_click, 3), elem(delete_row,0))
        # board = List.delete_at(board, Enum.at(game.last_click, 3) + 1)


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
                    [(10*(i+1))-(10-(j+1)), Enum.at(p1_shuffle, (10*(i+1))-(10-(j+1))-1), 1, i, j]
                i >= 6 ->
                    [(10*(i+1))-(10-(j+1)), Enum.at(p2_shuffle, 100 - ((10*(i+1))-(10-(j+1))+1)), 2, i, j]
                i > 3 && i < 6 ->
                    []
            end
        end)

    end)

    # Do we need this anymore?

    # p1_piece_map = %{"1": 1, "2": 8, "3": 5, "4": 4, "5": 4, "6": 4, "7": 3, "8": 2, "9": 1, "10": 1,"11": 6, "12": 1}
    # p2_piece_map = %{"1": 1, "2": 8, "3": 5, "4": 4, "5": 4, "6": 4, "7": 3, "8": 2, "9": 1, "10": 1,
    #     "11": 6, "12": 1
    # }
    #
    # Enum.map(1..10, fn i ->
    #     Enum.map(1..10, fn j ->
    #         cond do
    #             i <= 4 ->
    #                 {key, value, new_map} = get_random_piece(p1_piece_map)
    #                 p1_piece_map = Map.put(p1_piece_map, key, value)
    #                 [(10*i)-(10-j), key, 1]
    #
    #             i >= 7 ->
    #                 {key, value, new_map} = get_random_piece(p2_piece_map)
    #                 p2_piece_map = Map.put(p2_piece_map, key, value)
    #                 [(10*i)-(10-j), key, 2]
    #             i > 4 && i < 7 ->
    #                 []
    #         end
    #     end)
    # end)

  end

  # Do we need this anymore?
  def get_random_piece(map) do
      # select a piece where the value is not 0
    # {key,value} = Enum.random(map)
    # IO.puts(key)
    # IO.puts(value)
    # IO.puts(" ")
    # new_map = %{}
    # if (value - 1 == 0) do
    #     new_map = Map.delete(map, key)
    #     new_map = {key, value, new_map}
    # else
    #     newValue = value - 1
    #     # another_map = Map.put(map, key, newValue)
    #     # new_map = {key, value, another_map}
    #     IO.puts("entered")
    #     new_map = Map.get_and_update(map, key, fn key -> {key , newValue} end)
    #     IO.inspect(new_map)
    # end
    # IO.inspect(new_map)

    {key, value} = Enum.random(map)
    cond do
        value - 1 == 0 ->
            {key, value, Map.delete(map, key)}


        value - 1 != 0 ->
            {key, value, Map.put(map, key, value-1)}
    end
  end

end
