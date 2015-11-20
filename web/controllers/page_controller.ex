defmodule TexasHoldem.PageController do
  use TexasHoldem.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
