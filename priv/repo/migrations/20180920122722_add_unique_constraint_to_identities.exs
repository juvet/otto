defmodule Otto.Repo.Migrations.AddUniqueConstraintToIdentities do
  use Ecto.Migration

  def change do
    create(
      unique_index(
        :identities,
        [:access_token, :provider],
        name: :unique_provider_access_tokens
      )
    )
  end
end
