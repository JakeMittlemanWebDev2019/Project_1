defmodule Ogetarts.Game do

  def new do
    %{
      board: build_board()
    }
  end

  def client_view(game) do
    %{
        # array: [id, rank, player]
        board: game.board
    }
  end


  def build_board()  do

    p1 = [1, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6,
            7, 7, 7, 8, 8, 9, 10, 11, 11, 11, 11, 11, 11, 12]

    p2 = [1, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6,
            7, 7, 7, 8, 8, 9, 10, 11, 11, 11, 11, 11, 11, 12]

    p1_shuffle = Enum.shuffle(p1)
    p2_shuffle = Enum.shuffle(p2)

    Enum.map(1..10, fn i ->
        Enum.map(1..10, fn j ->
            cond do
                i <= 4 ->
                    [(10*i)-(10-j), Enum.at(p1_shuffle, (10*i)-(10-j)-1), 1]
                i >= 7 ->
                    [(10*i)-(10-j), Enum.at(p2_shuffle, 100 - ((10*i)-(10-j))), 2]
                i > 4 && i < 7 ->
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
