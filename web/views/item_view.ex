defmodule WishlistManager.ItemView do
  use WishlistManager.Web, :view

  def render("index.json", %{items: items}) do
    %{data: render_many(items, WishlistManager.ItemView, "item.json")}
  end

  def render("show.json", %{item: item}) do
    %{data: render_one(item, WishlistManager.ItemView, "item.json")}
  end

  def render("item.json", %{item: item}) do
    %{id: item.id,
      name: item.name,
      description: item.description,
      link: item.link,
      user_id: item.user_id}
  end
end
