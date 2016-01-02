defmodule WishlistManager.Credentials do
  use WishlistManager.Web, :model

  alias WishlistManager.Repo

  schema "credentials" do
    field :provider, :string
    field :user_identifier, :string
    field :password_hash, :string
    belongs_to :user, WishlistManager.User

    timestamps
  end

  @required_fields ~w(provider user_identifier)
  @optional_fields ~w(password_hash)

  @providers ~w(identity google)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:user_identifier)
  end

  def load_user(nil), do: :not_found
  def load_user(user), do: user |> Repo.preload [:user]
end
