defmodule WishlistManager.AuthController do
  use WishlistManager.Web, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers

  def request(conn, _params) do
    render(conn, "request.json", callback_url: Helpers.callback_url(conn))
    #render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def callback(%{ assigns: %{ ueberauth_failure: fails } } = conn, _params) do
    render(conn, "auth.json", data: "Error: #{inspect(fails)}")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    case validate_password(auth.credentials) do
      :ok ->
        # should create token here
        inspect(auth) |> IO.puts
        user = %{id: auth.uid, name: name_from_auth(auth), provider: auth.provider, email: auth.info.email, token: auth.credentials.token} #info to give to the client
        conn
        |> render("auth.json", data: IO.inspect(user))
      { :error, reason } ->
        conn
        |> render("auth.json", data: "Error: #{reason}")
    end
  end

  defp validate_password(credentials) do
    :ok
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
