defmodule Otto.IdentityTest do
  use ExUnit.Case

  alias Otto.{Repo, Identity}

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  describe "validations" do
    test "provider is required" do
      changeset = Identity.build(%{provider: ""})

      refute changeset.valid?

      assert changeset.errors[:provider] ==
               {"can't be blank", [validation: :required]}
    end

    test "access token is required" do
      changeset = Identity.build(%{access_token: ""})

      refute changeset.valid?

      assert changeset.errors[:access_token] ==
               {"can't be blank", [validation: :required]}
    end

    test "provider + access token must be unique" do
      Identity.create(%{access_token: "ATOKEN", provider: "slack"})

      {:error, changeset} =
        Identity.create(%{access_token: "ATOKEN", provider: "slack"})

      refute changeset.valid?

      assert changeset.errors[:provider_access_token] ==
               {"has already been taken", []}
    end

    test "provider must be supported" do
      changeset = Identity.build(%{provider: "blah"})

      refute changeset.valid?

      assert changeset.errors[:provider] ==
               {"is not a supported provider", [validation: :inclusion]}
    end
  end
end
