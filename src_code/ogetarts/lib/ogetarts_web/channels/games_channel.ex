defmodule OgetartsWeb.GamesChannel do
  use OgetartsWeb, :channel

  alias Ogetarts.Game
  # alias Ogetarts.BackupAgent

  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      # game = BackupAgent.get(name) || Game.new()
      game = Game.new()
      socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
      # BackupAgent.put(name, game)
      {:ok, %{"join" => name, "game" => Game.client_view(game)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("click", %{"key" => key}, socket) do
      game = socket.assigns[:game]
      game = Game.move_piece(game, key)
      {:reply, {:ok, %{ "game" => game }}, socket}
  end

  # Add authorization logic here as required.
  def authorized?(_payload) do
    true
  end
end
