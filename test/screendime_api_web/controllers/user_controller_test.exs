defmodule ScreendimeApiWeb.UserControllerTest do
  use ScreendimeApiWeb.ConnCase

  import ScreendimeApi.UsersFixtures
  alias ScreendimeApi.Users.User

  @create_attrs %{
    balance: 42,
    stake: 42,
    joined: ~U[2025-10-25 06:42:00Z],
    recharges_on: ~U[2025-10-25 06:42:00Z],
    last_penalty: ~U[2025-10-25 06:42:00Z]
  }
  @update_attrs %{
    balance: 43,
    stake: 43,
    joined: ~U[2025-10-26 06:42:00Z],
    recharges_on: ~U[2025-10-26 06:42:00Z],
    last_penalty: ~U[2025-10-26 06:42:00Z]
  }
  @invalid_attrs %{balance: nil, stake: nil, joined: nil, recharges_on: nil, last_penalty: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "balance" => 42,
               "joined" => "2025-10-25T06:42:00Z",
               "last_penalty" => "2025-10-25T06:42:00Z",
               "recharges_on" => "2025-10-25T06:42:00Z",
               "stake" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "balance" => 43,
               "joined" => "2025-10-26T06:42:00Z",
               "last_penalty" => "2025-10-26T06:42:00Z",
               "recharges_on" => "2025-10-26T06:42:00Z",
               "stake" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()

    %{user: user}
  end
end
