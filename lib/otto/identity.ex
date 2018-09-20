defmodule Otto.Identity do
  use Otto.Query, module: __MODULE__

  schema "identities" do
    field(:provider, :string)
    field(:access_token, :string)
    field(:uid, :string)
    field(:username, :string)

    timestamps()
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
end
