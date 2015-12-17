defmodule WishlistManager.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :birthday, :date
      add :email, :string #, unique: true

      timestamps
    end

  end
end
