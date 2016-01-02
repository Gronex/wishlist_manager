defmodule WishlistManager.AuthController do
  use WishlistManager.Web, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias WishlistManager.Credentials
  alias WishlistManager.User
  alias Comeonin.Bcrypt

  def request(conn, _params) do
    render(conn, "request.json", callback_url: Helpers.callback_url(conn))
  end

  def identity_callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case auth.uid do
      nil -> conn
        |> put_status(:bad_request)
        |> render("error.json", reason: "missing username")
      _ ->
        case Repo.get_by(Credentials, user_identifier: auth.uid) |> Credentials.load_user do
          :not_found ->
            Bcrypt.dummy_checkpw
            conn |> send_resp(401, "")
          creds ->
            if(Bcrypt.checkpw(auth.credentials.other.password, creds.password_hash)) do
              # should create token here
              result = %{name: User.full_name(creds.user), provider: :identity, email: creds.user_identifier, token: get_token(creds.user)} #info to give to the client
              conn
              |> render("auth.json", data: result)
            else
              conn |> send_resp(401, "")
            end
        end
    end
  end

  def callback(%{ assigns: %{ ueberauth_failure: fails } } = conn, _params) do
    render(conn, "auth.json", data: "Error: #{inspect(fails)}")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn,  %{"provider" => provider}) do
    # should create token here
    case Repo.get_by(Credentials, user_identifier: auth.uid) |> Credentials.load_user do
      :not_found ->
        user_changeset = User.changeset(%User{} ,%{first_name: auth.info.first_name, last_name: auth.info.last_name, email: auth.info.email})
        case Repo.insert(user_changeset) do
          {:ok, user} ->
            cred_changeset = Credentials.changeset(%Credentials{user_id: user.id}, %{provider: provider, user_identifier: auth.uid})
            {:ok, credentials} = Repo.insert(cred_changeset)
            conn
            |> put_status(:created)
            |> render("auth.json", data: %{name: name_from_auth(auth), provider: auth.provider, email: auth.info.email, token: get_token(user)})
          {:error, changeset} ->
            conn
            |> put_status(:bad_request)
            |> render(WishlistManager.ChangesetView, "error.json", changeset: changeset)
        end
      creds ->
        result = %{name: name_from_auth(auth), provider: auth.provider, email: auth.info.email, token: get_token(creds.user)} #info to give to the client
        conn
        |> render("auth.json", data: result)
    end
  end

  def register(conn, %{"user" => user_params}) do
    if user_params["password"] != user_params["confirm_password"] do
      conn
      |> put_status(:bad_request)
      |> render("error.json", reason: "confirm_password not matching password")
    else
      user_changeset = User.changeset(%User{email: user_params["username"]}, user_params)
      case Repo.insert(user_changeset) do
        {:ok, user} ->
          # TODO: check passwords in cred_changeset
          cred_changeset = Credentials.changeset(
            %Credentials{user_id: user.id, provider: Atom.to_string(:identity), user_identifier: user.email, password_hash: Bcrypt.hashpwsalt(user_params["password"])}, user_params)
          case Repo.insert(cred_changeset) do
            {:ok, credentials} ->
              conn
              |> put_status(:created)
              |> put_resp_header("location", item_path(conn, :show, user))
              |> render("auth.json", data: %{name: User.full_name(user), provider: :identity, email: user.email, token: get_token(user)})
            {:error, changeset} ->
              conn
              |> put_status(:unprocessable_entity)
              |> render(WishlistManager.ChangesetView, "error.json", changeset: changeset)
          end
        {:error, changeset} ->
          conn
          |> put_status(:bad_request)
          |> render(WishlistManager.ChangesetView, "error.json", changeset: changeset)
      end
    end
  end

  defp get_token(user) do
    user.email
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name = [auth.info.first_name, auth.info.last_name]
      |> Enum.filter(&(&1 != nil and &1 != ""))
      if length(name) == 0, do: auth.info.nickname, else: name = Enum.join(name, " ")
    end
  end
end
