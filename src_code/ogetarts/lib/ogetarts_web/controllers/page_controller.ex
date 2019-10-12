defmodule OgetartsWeb.PageController do
  use OgetartsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
