defmodule Otto.Repo.Migrations.CreateIdentity do
  use Ecto.Migration

  def change do
    create table(:identities) do
      add(:provider, :string)
      add(:access_token, :string)
      add(:uid, :string)
      add(:username, :string)

      timestamps()
    end
  end
end
