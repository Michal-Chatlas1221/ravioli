defmodule RavioliShop.Plugs.AuthenticateUserTest do
  use RavioliShop.ConnCase, async: true
  alias RavioliShop.Plugs.AuthenticateUser
  alias RavioliShop.User

  test "token is invalid", %{conn: conn} do
    conn = put_req_header(conn, "x-auth-token", "")
    conn = AuthenticateUser.call(conn, %{})

    assert conn.status == 401
    assert conn.halted
  end

  test "token is missing", %{conn: conn} do
    conn = AuthenticateUser.call(conn, %{})

    assert conn.status == 401
    assert conn.halted
  end

  test "token is valid", %{conn: conn} do
    {:ok, user} = Repo.insert(%User{auth_token: "token"})
    conn = put_req_header(conn, "x-auth-token", user.auth_token)
    conn = AuthenticateUser.call(conn, %{})

    refute conn.halted
  end
end
