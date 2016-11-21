defmodule Ravioli.AuthController do
  use Ravioli.Web, :controller

  alias Ravioli.ErrorView

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Ravioli.Auth.get_auth_token(email, password) do
      {:ok, token} ->
        render(conn, "sign_in.json", token: token)
      {:error, _} ->
        conn |> put_status(:unauthorized) |> render(ErrorView, "401.json")
    end
  end
end
