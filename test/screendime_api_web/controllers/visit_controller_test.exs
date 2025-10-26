defmodule ScreendimeApiWeb.VisitControllerTest do
  use ScreendimeApiWeb.ConnCase

  import ScreendimeApi.TrackingFixtures
  alias ScreendimeApi.Tracking.Visit

  @create_attrs %{
    url: "some url",
    visited_at: ~U[2025-10-25 14:22:00Z]
  }
  @update_attrs %{
    url: "some updated url",
    visited_at: ~U[2025-10-26 14:22:00Z]
  }
  @invalid_attrs %{url: nil, visited_at: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all visits", %{conn: conn} do
      conn = get(conn, ~p"/api/visits")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create visit" do
    test "renders visit when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/visits", visit: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/visits/#{id}")

      assert %{
               "id" => ^id,
               "url" => "some url",
               "visited_at" => "2025-10-25T14:22:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/visits", visit: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update visit" do
    setup [:create_visit]

    test "renders visit when data is valid", %{conn: conn, visit: %Visit{id: id} = visit} do
      conn = put(conn, ~p"/api/visits/#{visit}", visit: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/visits/#{id}")

      assert %{
               "id" => ^id,
               "url" => "some updated url",
               "visited_at" => "2025-10-26T14:22:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, visit: visit} do
      conn = put(conn, ~p"/api/visits/#{visit}", visit: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete visit" do
    setup [:create_visit]

    test "deletes chosen visit", %{conn: conn, visit: visit} do
      conn = delete(conn, ~p"/api/visits/#{visit}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/visits/#{visit}")
      end
    end
  end

  defp create_visit(_) do
    visit = visit_fixture()

    %{visit: visit}
  end
end
