defmodule OttoWeb.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use OttoWeb, :controller
  plug(Ueberauth)

  alias Ueberauth.Strategy.Helpers
  alias Otto.Identity

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: page_path(conn, :index))
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Identity.find_or_create_from_auth(auth) do
      {:ok, _identity} ->
        conn
        |> put_flash(:info, "Welcome!")
        |> redirect(to: settings_path(conn, :index))

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: page_path(conn, :index))
    end
  end
end
