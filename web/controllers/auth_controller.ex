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
        user = %{id: auth.uid, name: name_from_auth(auth)} #info to give to the client
        conn
        |> render("auth.json", data: "Success: #{inspect(user)}")
      { :error, reason } ->
        conn
        |> render("auth.json", data: "Error: #{reason}")
    end
  end

  defp validate_password(pass) do
    IO.puts inspect(pass)
    :ok
  end
  defp name_from_auth(auth), do: "test"
end
