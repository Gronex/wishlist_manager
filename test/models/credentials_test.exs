defmodule WishlistManager.CredentialsTest do
  use WishlistManager.ModelCase

  alias WishlistManager.Credentials

  @valid_attrs %{password_hash: "some content", provider: "some content", user_identifier: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Credentials.changeset(%Credentials{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Credentials.changeset(%Credentials{}, @invalid_attrs)
    refute changeset.valid?
  end
end
