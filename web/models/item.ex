defmodule WishlistManager.Item do
  use WishlistManager.Web, :model

  schema "items" do
    field :name, :string
    field :description, :string
    field :link, :string
    belongs_to :user, WishlistManager.User

    timestamps
  end

  @required_fields ~w(name user_id)
  @optional_fields ~w(description link)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:user_id)
  end
end
