defmodule Ogetarts.Game do

  def new do
    %{
      board: [[],[],[],[],[],[],[],[],[],[]]
    }
  end

  def client_view(game) do
    %{
      board: [
          [[1,1,1],[2,3,1],[3,3,1],[4,1,2],[5,5,2],[6,3,2],[7,4,2],[8,6,1],[9,5,1],[10,1,2]]
      ]
    }

  end

end
