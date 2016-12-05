defmodule RavioliShop.AuthView do
  use RavioliShop.Web, :view

  def render("sign_in.json", %{user: user}) do
    %{
      email: user.email,
      token: user.auth_token,
    }
  end
end
