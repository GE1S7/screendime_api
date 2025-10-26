defmodule ScreendimeApiWeb.BlockedPatternControllerTest do
  use ScreendimeApiWeb.ConnCase

  import ScreendimeApi.BlockingFixtures
  alias ScreendimeApi.Blocking.BlockedPattern

  @create_attrs %{
    pattern: "some pattern"
  }
  @update_attrs %{
    pattern: "some updated pattern"
  }
  @invalid_attrs %{pattern: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all blocked_patterns", %{conn: conn} do
      conn = get(conn, ~p"/api/blocked_patterns")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create blocked_pattern" do
    test "renders blocked_pattern when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/blocked_patterns", blocked_pattern: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/blocked_patterns/#{id}")

      assert %{
               "id" => ^id,
               "pattern" => "some pattern"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/blocked_patterns", blocked_pattern: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update blocked_pattern" do
    setup [:create_blocked_pattern]

    test "renders blocked_pattern when data is valid", %{conn: conn, blocked_pattern: %BlockedPattern{id: id} = blocked_pattern} do
      conn = put(conn, ~p"/api/blocked_patterns/#{blocked_pattern}", blocked_pattern: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/blocked_patterns/#{id}")

      assert %{
               "id" => ^id,
               "pattern" => "some updated pattern"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, blocked_pattern: blocked_pattern} do
      conn = put(conn, ~p"/api/blocked_patterns/#{blocked_pattern}", blocked_pattern: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete blocked_pattern" do
    setup [:create_blocked_pattern]

    test "deletes chosen blocked_pattern", %{conn: conn, blocked_pattern: blocked_pattern} do
      conn = delete(conn, ~p"/api/blocked_patterns/#{blocked_pattern}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/blocked_patterns/#{blocked_pattern}")
      end
    end
  end

  defp create_blocked_pattern(_) do
    blocked_pattern = blocked_pattern_fixture()

    %{blocked_pattern: blocked_pattern}
  end
end
