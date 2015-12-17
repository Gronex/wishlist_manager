defmodule WishlistManager.ItemControllerTest do
  use WishlistManager.ConnCase

  alias WishlistManager.Item
  alias WishlistManager.User

  @valid_attrs %{description: "some content", link: "some content", name: "some content", user_id: -1}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok,conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, item_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    item = Repo.insert! %Item{user_id: user.id}
    conn = get conn, item_path(conn, :show, item)
    assert json_response(conn, 200)["data"] == %{"id" => item.id,
      "name" => item.name,
      "description" => item.description,
      "link" => item.link,
      "user_id" => item.user_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, item_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = post conn, item_path(conn, :create), item: %{@valid_attrs | user_id: user.id}
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Item, %{@valid_attrs | user_id: user.id})
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, item_path(conn, :create), item: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user = Repo.insert! %User{}
    item = Repo.insert! %Item{user_id: user.id}
    conn = put conn, item_path(conn, :update, item), item: %{@valid_attrs | user_id: user.id}
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Item, %{@valid_attrs | user_id: user.id})
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.insert! %User{}
    item = Repo.insert! %Item{user_id: user.id}
    conn = put conn, item_path(conn, :update, item), item: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    item = Repo.insert! %Item{user_id: user.id}
    conn = delete conn, item_path(conn, :delete, item)
    assert response(conn, 204)
    refute Repo.get(Item, item.id)
  end
end
