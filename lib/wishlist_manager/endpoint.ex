defmodule WishlistManager.Endpoint do
  use Phoenix.Endpoint, otp_app: :wishlist_manager

  socket "/socket", WishlistManager.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :wishlist_manager, gzip: false,
    only: ~w(node_modules bower_components build app css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_wishlist_manager_key",
    signing_salt: "gxPX1Qfx"

  plug CORSPlug, [origin: "*"]
  plug WishlistManager.Router
end
