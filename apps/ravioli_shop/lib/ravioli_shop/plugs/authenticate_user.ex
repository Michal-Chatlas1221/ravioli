defmodule RavioliShop.Plugs.AuthenticateUser do
  import Plug.Conn
  alias RavioliShop.{User, Repo}

  def init(options), do: options

  def call(%Plug.Conn{} = conn, _options) do
  	with token when is_binary(token) <- Enum.join(get_req_header(conn, "x-auth-token")),
    %User{} = user <- Repo.get_by(User, auth_token: token)
  	do conn |> assign(:current_user, user)   
   	else _ -> conn |> send_resp(:unauthorized, "") |> halt
   	end 
  end 
end