# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     WishlistManager.Repo.insert!(%WishlistManager.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#user = WishlistManager.Repo.insert!(%WishlistManager.User{first_name: "Mads", last_name: "Slotsbo", birthday: Ecto.Date.cast!("1993-01-29"), email: "mads.slotsbo@gmail.com"})
#WishlistManager.Repo.insert!(%WishlistManager.Item{name: "item of the first degree", description: "awesomeness", user_id: user.id})
