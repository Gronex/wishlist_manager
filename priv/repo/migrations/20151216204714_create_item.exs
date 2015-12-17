defmodule WishlistManager.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :description, :string
      add :link, :string
      add :user_id, references(:users), null: false

      timestamps
    end
    create index(:items, [:user_id])

  end
end
