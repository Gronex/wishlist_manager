defmodule WishlistManager.AuthView do
  use WishlistManager.Web, :view

  def render("request.json", %{callback_url: url}) do
    %{callback_url: url}
  end

  def render("auth.json", %{data: data}) do
    %{data: data}
  end

end
