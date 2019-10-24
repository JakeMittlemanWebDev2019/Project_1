defmodule Ogetarts.GameServer do
    use GenServer
  
    def reg(name) do
      {:via, Registry, {Ogetarts.GameReg, name}}
    end
  
    def start(name) do
      spec = %{
        id: __MODULE__,
        start: {__MODULE__, :start_link, [name]},
        restart: :permanent,
        type: :worker
      }
      Ogetarts.GameSup.start_child(spec)
    end
  
    def start_link(name) do
      game = Ogetarts.BackupAgent.get(name) || Ogetarts.Game.new()
      GenServer.start_link(__MODULE__, game, name: reg(name))
    end
  
    def move_piece(name, i, j) do
        GenServer.call(reg(name), {:click, name, i, j})
    end

    def reset_game(name) do
        GenServer.call(reg(name), {:reset, name})
    end

    def peek(name, user) do
        GenServer.call(reg(name), {:peek, name, user})
    end

  
    # Implementation
  
    def init(game) do
      {:ok, game}
    end
  
    def handle_call({:click, name, i, j}, _from, game) do
      IO.puts("in game server:")
      IO.inspect(game)
      game = Ogetarts.Game.move_piece(game, i, j)
      Ogetarts.BackupAgent.put(name, game)
      {:reply, game, game}
    end
  
    def handle_call({:reset, name}, _from, game) do
      game = Ogetarts.Game.reset_game()
      Ogetarts.BackupAgent.put(name, game)
      {:reply, game, game}
    end

    def handle_call({:peek, name, user}, _from, game) do
      if (length(game.players) <= 2) do
        game = Map.merge(game, %{players: (game.players ++ [user])})
        Ogetarts.BackupAgent.put(name, game)
        {:reply, game, game}
      else
        {:reply, game, game}
      end
    end
  end