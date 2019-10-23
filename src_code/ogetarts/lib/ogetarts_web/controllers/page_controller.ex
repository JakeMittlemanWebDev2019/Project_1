defmodule OgetartsWeb.PageController do
  use OgetartsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def game(conn, %{"name" => name}) do
    user = get_session(conn, :user)
    if (user) do
      render(conn, "game.html", name: name)
    else
      conn
      |> put_flash(:error, "Username cannot be blank")
      |> redirect(to: "/")
    end
  end

  def join(conn, %{"user" => user, "name" => name}) do
    conn
    |> put_session(:user, user)
    |> redirect(to: Routes.page_path(conn, :game, name))
  end

end
