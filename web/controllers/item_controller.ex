defmodule WishlistManager.ItemController do
  use WishlistManager.Web, :controller
  use Guardian.Phoenix.Controller

  alias WishlistManager.Item

  plug :scrub_params, "item" when action in [:create, :update]

  def index(conn, _params, _user, _claims) do
    items = Repo.all(Item)
    render(conn, "index.json", items: items)
  end

  def create(conn, %{"item" => item_params}, user, _claims) do
    changeset = Item.changeset(%Item{user_id: user.id}, item_params)

    case Repo.insert(changeset) do
      {:ok, item} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", item_path(conn, :show, item))
        |> render("show.json", item: item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(WishlistManager.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _user, _claims) do
    item = Repo.get!(Item, id)
    render(conn, "show.json", item: item)
  end

  def update(conn, %{"id" => id, "item" => item_params}, user, _claims) do
    item = Repo.get!(Item, id)

    unless(user.id == item.user_id) do
      WishlistManager.AuthController.unauthenticated(conn, item_params)
    else
      changeset = Item.changeset(item, item_params)

      case Repo.update(changeset) do
        {:ok, item} ->
          render(conn, "show.json", item: item)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(WishlistManager.ChangesetView, "error.json", changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}, user, _claims) do
      item = Repo.get!(Item, id)
    unless(user.id == item.user_id) do
      WishlistManager.AuthController.unauthenticated(conn, id)
    else

      # Here we use delete! (with a bang) because we expect
      # it to always work (and if it does not, it will raise).
      Repo.delete!(item)

      send_resp(conn, :no_content, "")
    end
  end
end
