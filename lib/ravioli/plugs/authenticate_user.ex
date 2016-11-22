defmodule Ravioli.Plugs.AuthenticateUser do
  import Plug.Conn
  alias Ravioli.{User, Repo}

  def init(options), do: options

  def call(%Plug.Conn{} = conn, _options) do
  	case Enum.join(get_req_header(conn, "x-auth-token")) do
  		x = x -> case Repo.get_by(User, auth_token: x) do
  		  %User{} = user -> conn |> assign(:current_user, user)
  		  nil -> conn |> put_status(:unauthorised) |> halt
  		end  	
  		nil -> conn |> put_status(:unauthorised) |> halt
  	end	
  end
end