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

  describe ".for_access_token" do
    test "returns a tuple with the identity if found" do
      Identity.create(%{provider: "slack", access_token: "ATOKEN"})

      assert {:ok, identity} = Identity.for_access_token(:slack, "ATOKEN")
      assert identity.provider == "slack"
      assert identity.access_token == "ATOKEN"
    end

    test "returns a not found error tuple if not found" do
      assert {:error, :not_found} = Identity.for_access_token(:slack, "blah")
    end
  end

  describe ".for_uid" do
    test "returns a tuple with the identity if found" do
      Identity.create(%{provider: "slack", access_token: "ATOKEN", uid: "UID"})

      assert {:ok, identity} = Identity.for_uid(:slack, "UID")
      assert identity.provider == "slack"
      assert identity.uid == "UID"
    end

    test "returns a not found error tuple if not found" do
      assert {:error, :not_found} = Identity.for_uid(:slack, "blah")
    end
  end

  describe ".find_or_create_from_auth with Slack" do
    @auth %{
      credentials: %{
        token: "SLACK_TOKEN",
        other: %{user: "jimmyp", user_id: "USLACKUID"}
      },
      provider: :slack
    }

    test "creates a new identity" do
      {:ok, identity, _} = Identity.find_or_create_from_auth(@auth)

      assert identity.provider == "slack"
      assert identity.access_token == "SLACK_TOKEN"
      assert identity.uid == "USLACKUID"
      assert identity.username == "jimmyp"
    end

    test "create returns the correct metadata" do
      assert {:ok, _identity, %{new_record?: true}} =
               Identity.find_or_create_from_auth(@auth)
    end

    test "updates the identity for the provider and access_token" do
      {:ok, identity} =
        Identity.create(%{
          provider: "slack",
          uid: "BLAH",
          access_token: "SLACK_TOKEN"
        })

      {:ok, found_identity, _} = Identity.find_or_create_from_auth(@auth)

      assert identity.id == found_identity.id
      assert found_identity.uid == "USLACKUID"
    end

    test "updates the identity for the provider and uid" do
      {:ok, identity} =
        Identity.create(%{
          provider: "slack",
          uid: "USLACKUID",
          access_token: "BLAH"
        })

      {:ok, found_identity, _} = Identity.find_or_create_from_auth(@auth)

      assert identity.id == found_identity.id
      assert found_identity.access_token == "SLACK_TOKEN"
    end

    test "update returns the correct metadata" do
      {:ok, identity} =
        Identity.create(%{
          provider: "slack",
          uid: "USLACKUID",
          access_token: "BLAH"
        })

      assert {:ok, _identity, %{new_record?: false}} =
               Identity.find_or_create_from_auth(@auth)
    end
  end
end
