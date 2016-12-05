defmodule RavioliShop.AuthTest do
  use RavioliShop.ModelCase, async: true

  alias RavioliShop.{Auth, User}

  @email "foo@bar.com"
  @password "password"

  setup do
    {:ok, user} =
      %User{}
      |> User.changeset(%{email: @email, password: @password})
      |> Repo.insert()

    {:ok, user: user}
  end

  describe "get_auth_token" do
    test "for non existing user" do
      assert {:error, :unauthorized} = Auth.get_auth_token("invalid", "invalid")
    end

    test "with invalid password" do
      assert {:error, _} = Auth.get_auth_token(@email, "invalid")
    end

    test "with valid credentials" do
      assert {:ok, _} = Auth.get_auth_token(@email, @password)
    end
  end

  describe "find_user_or_create_new" do
    test "for existing user", %{user: user} do
      assert user == Auth.find_user_or_create_new(@email, @password)
    end

    test "for a new user" do
      assert {:ok, %User{email: "new@email"}} =
        Auth.find_user_or_create_new("new@email", "password")
    end
  end
end
