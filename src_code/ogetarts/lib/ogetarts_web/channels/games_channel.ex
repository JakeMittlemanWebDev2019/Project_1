defmodule OgetartsWeb.GamesChannel do
  use OgetartsWeb, :channel

  alias Ogetarts.Game
  alias Ogetarts.BackupAgent

  intercept ["update"]

  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      Ogetarts.GameServer.start(name)
      game = Ogetarts.GameServer.peek(name, socket.assigns[:user])

      # game = BackupAgent.get(name) || Game.new()

      socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
      BackupAgent.put(name, game)
      {:ok, %{"join" => name, "game" => Game.client_view(game, socket.assigns[:user])}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("click", %{"i" => i, "j" => j}, socket) do
      name = socket.assigns[:name]
      user = socket.assigns[:user]

      game = Ogetarts.GameServer.move_piece(name, user, i, j)

      # game = Game.move_piece(game, i, j)

      socket = assign(socket, :game, game)
      BackupAgent.put(name, game)
      broadcast!(socket, "update", %{game: game})
      {:reply, {:ok, %{ "game" => Game.client_view(game, user)}}, socket}
  end

  def handle_in("reset", _payload, socket) do
      name = socket.assigns[:name]

      game = Ogetarts.GameServer.reset_game(name)
      # Game.reset_game()
      socket = assign(socket, :game, game)
      BackupAgent.put(name, game)
      {:reply, {:ok, %{ "game" => Game.client_view(game, socket.assigns[:user])}}, socket}
  end

  def handle_in("chat", %{"message" => message}, socket) do
    name = socket.assigns[:name]
    user = socket.assigns[:user]
    broadcast!(socket, "new message", %{message: message, user: user})
    {:noreply, socket}
  end

  def handle_out("update", payload, socket) do
    push(socket, "update", %{ "game" => Game.client_view(payload.game, socket.assigns[:user]) })
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  def authorized?(_payload) do
    true
  end
end
