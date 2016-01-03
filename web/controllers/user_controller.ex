defmodule WishlistManager.UserController do
  use WishlistManager.Web, :controller
  use Guardian.Phoenix.Controller

  alias WishlistManager.User

  plug :scrub_params, "user" when action in [:create, :update]

  def index(conn, _params, _user, _claims) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def show(conn, %{"id" => id}, _user, _claims) do
    user = Repo.get!(User, id) |> Repo.preload [:items]
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}, c_user, _claims) do
    unless(to_string(c_user.id) == id) do
      WishlistManager.AuthController.unauthenticated(conn, user_params)
    else
      user = Repo.get!(User, id)
      changeset = User.changeset(user, user_params)

      case Repo.update(changeset) do
        {:ok, user} ->
          render(conn, "show.json", user: user |> Repo.preload [:items])
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(WishlistManager.ChangesetView, "error.json", changeset: changeset)
      end
    end
  end
end
