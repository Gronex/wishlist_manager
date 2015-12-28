defmodule WishlistManager.UserView do
  use WishlistManager.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, WishlistManager.UserView, "users.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, WishlistManager.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      firstName: user.first_name,
      lastName: user.last_name,
      birthday: user.birthday,
      items: render_many(user.items, WishlistManager.ItemView, "item.json")}
  end

  def render("users.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      firstName: user.first_name,
      lastName: user.last_name,
      birthday: user.birthday}
  end
end
