defmodule OttoWeb.AuthControllerTest do
  use OttoWeb.ConnCase

  alias Otto.{Identity, Repo}

  describe "POST /auth/slack/callback" do
    @ueberauth_auth %{
      credentials: %{
        token: "SLACK_TOKEN",
        other: %{user: "jimmyp", user_id: "USLACKUID"}
      },
      provider: :slack
    }

    setup do
      conn = build_conn() |> assign(:ueberauth_auth, @ueberauth_auth)

      {:ok, conn: conn}
    end

    test "creates an identity with the slack information", %{conn: conn} do
      post(conn, auth_path(conn, :callback, :slack))

      result = Identity |> Ecto.Query.last() |> Repo.one()

      assert result.provider == "slack"
      assert result.access_token == "SLACK_TOKEN"
      assert result.uid == "USLACKUID"
      assert result.username == "jimmyp"
    end

    test "redirects to the settings page when identity already exists", %{
      conn: conn
    } do
      conn = post(conn, auth_path(conn, :callback, :slack))

      assert redirected_to(conn) =~ settings_path(conn, :index)
    end
  end
end
