defmodule OgetartsWeb.PageController do
  use OgetartsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def game(conn, %{"name" => name}) do
    render(conn, "game.html", name: name)
  end

  def join(conn, %{"name" => name}) do
    redirect(conn, to: Routes.page_path(conn, :game, name))
  end

end
