defmodule OgetartsWeb.PageController do
  use OgetartsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  # def game(conn, %{"name" => name}) do
  #   render(conn, "game.html", name: name)
  # end

  def game(conn, %{"name" => name}) do
    render(conn, "game.html", name: "games/" <> name)
  end

end
