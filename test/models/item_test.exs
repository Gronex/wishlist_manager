defmodule WishlistManager.ItemTest do
  use WishlistManager.ModelCase

  alias WishlistManager.Item

  @valid_attrs %{description: "some content", link: "some content", name: "some content", user_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Item.changeset(%Item{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Item.changeset(%Item{}, @invalid_attrs)
    refute changeset.valid?
  end
end
