defmodule OgetartsWeb.PageController do
  use OgetartsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def game(conn, %{"name" => name, "user" => user}) do
    render(conn, "game.html", user: user, name: name)
  end

  def join(conn, %{"name" => name, "user" => user}) do
    redirect(conn, to: Routes.page_path(conn, :game, user: user, name))
  end

end
