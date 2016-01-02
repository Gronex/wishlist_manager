defmodule WishlistManager.AuthController do
  use WishlistManager.Web, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias WishlistManager.Credentials
  alias WishlistManager.User

  def request(conn, _params) do
    render(conn, "request.json", callback_url: Helpers.callback_url(conn))
  end

  def callback_identity(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => :identity}) do
    # should create token here
    inspect(auth) |> IO.puts
    case Repo.get_by(Credentials, user_identifier: auth.uid) |> Credentials.load_user do #TODO: validate password
      :not_found ->
        conn
        |> put_status(:unautorized)
        |> render("error.json")
      creds ->
        result = %{name: User.full_name(creds.user), provider: :identity, email: creds.user_identifier, token: get_token(creds.user)} #info to give to the client
        conn
        |> render("auth.json", data: result)
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
            IO.puts inspect(user.id)
            cred_changeset = Credentials.changeset(%Credentials{user_id: user.id}, %{provider: provider, user_identifier: auth.uid})
            {:ok, credentials} = Repo.insert(cred_changeset)
            conn
            |> put_status(:created)
            |> render("auth.json", data: %{name: name_from_auth(auth), provider: auth.provider, email: auth.info.email, token: get_token(user)})
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(WishlistManager.ChangesetView, "error.json", changeset: changeset)
        end
      creds ->
        result = %{name: name_from_auth(auth), provider: auth.provider, email: auth.info.email, token: get_token(creds.user)} #info to give to the client
        conn
        |> render("auth.json", data: result)
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
