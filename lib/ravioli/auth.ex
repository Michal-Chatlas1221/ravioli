defmodule Ravioli.Auth do
  alias Ravioli.{Repo, User}

  @token_length 20

  def get_auth_token(email, password) do
    User
    |> Repo.get_by(email: email)
    |> authenticate(password)
    |> get_auth_token()
  end

  def find_user_or_create_new(email, password) do
    user = User.changeset(%User{}, %{"email": email, "password": password})
    if (!Repo.get_by(User, email: email)) do
      Repo.insert(user);
    end  
  end

  defp authenticate(%User{} = user, password) do
    if Comeonin.Bcrypt.checkpw(password, user.password) do
      {:ok, user}
    else
      {:error, :unauthorized}
    end
  end
  defp authenticate(_, _), do: {:error, :unauthorized}

  defp get_auth_token({:error, error}), do: {:error, error}
  defp get_auth_token({:ok, %User{auth_token: nil} = user}) do
    token = generate_token()

    user
    |> User.sign_in_changeset(%{auth_token: token})
    |> Repo.update()

    {:ok, token}
  end
  defp get_auth_token({:ok, %User{auth_token: token}}), do: {:ok, token}

  defp generate_token() do
    :crypto.strong_rand_bytes(@token_length)
    |> Base.url_encode64
    |> binary_part(0, @token_length)
  end
end
