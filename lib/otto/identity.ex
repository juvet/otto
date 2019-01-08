defmodule Otto.Identity do
  use Otto.Query, module: __MODULE__

  schema "identities" do
    field(:provider, :string)
    field(:access_token, :string)
    field(:uid, :string)
    field(:username, :string)

    timestamps()
  end

  def for_access_token(provider, access_token) do
    if identity =
         Repo.get_by(
           __MODULE__,
           provider: to_string(provider),
           access_token: access_token
         ) do
      {:ok, identity}
    else
      {:error, :not_found}
    end
  end

  def for_uid(provider, uid) do
    if identity =
         Repo.get_by(
           __MODULE__,
           provider: to_string(provider),
           uid: uid
         ) do
      {:ok, identity}
    else
      {:error, :not_found}
    end
  end

  def find_or_create_from_auth(%{
        provider: :slack,
        credentials: %{
          token: access_token,
          other: %{user: username, user_id: uid}
        }
      }) do
    case(for_access_token(:slack, access_token)) do
      {:ok, identity} ->
        update_identity(identity, uid, username, access_token)

      {:error, :not_found} ->
        case(for_uid(:slack, uid)) do
          {:ok, identity} ->
            update_identity(identity, uid, username, access_token)

          {:error, :not_found} ->
            create(%{
              provider: "slack",
              access_token: access_token,
              username: username,
              uid: uid
            })
            |> Tuple.append(%{new_record?: true})
        end
    end
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:provider, :access_token, :uid, :username])
    |> validate_required([:access_token, :provider])
    |> validate_inclusion(
      :provider,
      ["slack"],
      message: "is not a supported provider"
    )
    |> unique_constraint(
      :provider_access_token,
      name: :unique_provider_access_tokens
    )
  end

  defp update_identity(identity, uid, username, access_token) do
    __MODULE__.changeset(identity, %{
      uid: uid,
      username: username,
      access_token: access_token
    })
    |> Repo.update()
    |> Tuple.append(%{new_record?: false})
  end
end
