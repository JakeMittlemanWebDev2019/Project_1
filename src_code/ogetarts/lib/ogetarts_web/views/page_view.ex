defmodule OgetartsWeb.PageView do
  use OgetartsWeb, :view

  def connection_keys(conn) do
    conn.assigns
    |> Map.keys()
  end
end
