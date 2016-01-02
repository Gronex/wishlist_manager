defmodule WishlistManager.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  def change do
    create table(:credentials) do
      add :provider, :string
      add :user_identifier, :string
      add :password_hash, :string
      add :user_id, references(:users)

      timestamps
    end
    create index(:credentials, [:user_id])
    create unique_index(:credentials, [:user_identifier])

  end
end
