defmodule WishlistManager.UserTest do
  use WishlistManager.ModelCase

  alias WishlistManager.User

  @valid_attrs %{birthday: "2010-04-17", first_name: "some content", last_name: "some content", email: "test@test.com"}
  @invalid_attrs %{}
  @invalid_email_attrs %{birthday: "2010-04-17", first_name: "some content", last_name: "some content", email: "testtest.com"}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with invalid email format" do
    changeset = User.changeset(%User{}, @invalid_email_attrs)
    refute changeset.valid?
  end
end
