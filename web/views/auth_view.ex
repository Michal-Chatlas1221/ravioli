defmodule Ravioli.AuthView do
  use Ravioli.Web, :view

  def render("sign_in.json", %{token: token}) do
    %{auth_token: token}
  end
end
