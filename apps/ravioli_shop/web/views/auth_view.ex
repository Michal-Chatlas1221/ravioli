defmodule RavioliShop.AuthView do
  use RavioliShop.Web, :view

  def render("sign_in.json", %{token: token}) do
    %{auth_token: token}
  end
end
