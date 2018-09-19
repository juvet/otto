defmodule OttoWeb.PageController do
  use OttoWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
