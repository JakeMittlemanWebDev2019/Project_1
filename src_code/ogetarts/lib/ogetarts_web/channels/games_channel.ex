defmodule OgetartsWeb.GamesChannel do
  use OgetartsWeb, :channel

  alias Ogetarts.Game
  alias Ogetarts.BackupAgent

  intercept ["new message"]

  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do

      Ogetarts.GameServer.start(name)
      game = Ogetarts.GameServer.peek(name)

      # game = BackupAgent.get(name) || Game.new()

      socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
      BackupAgent.put(name, game)
      {:ok, %{"join" => name, "game" => Game.client_view(game)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("click", %{"i" => i, "j" => j}, socket) do
      name = socket.assigns[:name]
      # game = socket.assigns[:game]

      game = Ogetarts.GameServer.move_piece(name, i, j)

      # game = Game.move_piece(game, i, j)

      socket = assign(socket, :game, game)
      BackupAgent.put(name, game)
      {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
  end

  def handle_in("reset", _payload, socket) do
      name = socket.assigns[:name]

      game = Ogetarts.GameServer.reset_game(name)
      # Game.reset_game()
      socket = assign(socket, :game, game)
      BackupAgent.put(name, game)
      {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
  end

  def handle_in("chat", %{"message" => message}, socket) do
    name = socket.assigns[:name]
    IO.puts("in handle in")
    IO.puts(message)
    broadcast!("games:" <> name, "new message", %{message: message})
    {:noreply, socket}
  end

  def handle_out("new message", %{"message" => message}, socket) do
    name = socket.assigns[:name]
    game = Ogetarts.GameServer.peek(name)
    {payload} = message
    chatMessage = payload.message
    game = Map.merge(game, %{last_message: message.message})
    IO.puts(message.message)
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  # Add authorization logic here as required.
  def authorized?(_payload) do
    true
  end
end
