defmodule RavioliShop.AuthController do
  use RavioliShop.Web, :controller

  alias RavioliShop.{ErrorView, Auth}

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Auth.get_user(email, password) do
      {:ok, user} ->
        render(conn, "sign_in.json", user: user)
      {:error, _} ->
        conn |> put_status(:unauthorized) |> render(ErrorView, "401.json")
    end
  end

  def sign_up(conn, %{"email" => email, "password" => password} = params) do
    Auth.find_user_or_create_new(email, password)
    sign_in(conn, params)
  end
end
