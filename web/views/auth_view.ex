defmodule Ravioli.AuthView do
  use Ravioli.Web, :view

  def render("sign_in.json", %{token: token}) do
    %{auth_token: token}
  end

  def render("sign_up.json", %{email: email, password: password}) do
  	%{email: email, password: password}
  end	
end
