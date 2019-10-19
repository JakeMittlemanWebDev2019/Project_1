defmodule Ogetarts.Game do

    #TODO: validate legal moves per each rank (not for flags or bombs)
    #TODO: attacking logic for ranked pieces
    #TODO: highlight clicked pieces
    #TODO: highlight available moves
    #TODO: implementing water in middle

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
    # _board = List.insert_at(board, i, elem(new_row,0))
    # List.delete_at(_board, i+1)
    List.replace_at(board, i, elem(new_row,0))
  end

  def move_piece(game, i, j) do
    if (length(game.last_click) == 0) do
        row = Enum.at(game.board, i)
        piece = Enum.at(row, j)

        if (length(piece) != 0) do
            Map.put(game, :last_click, piece)
        else
            game
        end
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
                    [(10*(i+1))-(10-(j+1)), Enum.at(p1_shuffle, (10*(i+1))-(10-(j+1))-1), 1, i, j]
                i >= 6 ->
                    [(10*(i+1))-(10-(j+1)), Enum.at(p2_shuffle, 100 - ((10*(i+1))-(10-(j+1))+1)), 2, i, j]
                i > 3 && i < 6 ->
                    []
            end
        end)

    end)

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
