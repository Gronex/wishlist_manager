defmodule WishlistManager.User do
  use WishlistManager.Web, :model

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :birthday, Ecto.Date
    field :email, :string

    has_many :items, WishlistManager.Item
    timestamps
  end

  @required_fields ~w(email first_name last_name)
  @optional_fields ~w(birthday)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/^(\S+)@(\S+)\.(\S+)$/)
  end
end
