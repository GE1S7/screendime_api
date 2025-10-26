defmodule ScreendimeApi.TrackingTest do
  use ScreendimeApi.DataCase

  alias ScreendimeApi.Tracking

  describe "visits" do
    alias ScreendimeApi.Tracking.Visit

    import ScreendimeApi.TrackingFixtures

    @invalid_attrs %{url: nil, visited_at: nil}

    test "list_visits/0 returns all visits" do
      visit = visit_fixture()
      assert Tracking.list_visits() == [visit]
    end

    test "get_visit!/1 returns the visit with given id" do
      visit = visit_fixture()
      assert Tracking.get_visit!(visit.id) == visit
    end

    test "create_visit/1 with valid data creates a visit" do
      valid_attrs = %{url: "some url", visited_at: ~U[2025-10-25 14:22:00Z]}

      assert {:ok, %Visit{} = visit} = Tracking.create_visit(valid_attrs)
      assert visit.url == "some url"
      assert visit.visited_at == ~U[2025-10-25 14:22:00Z]
    end

    test "create_visit/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracking.create_visit(@invalid_attrs)
    end

    test "update_visit/2 with valid data updates the visit" do
      visit = visit_fixture()
      update_attrs = %{url: "some updated url", visited_at: ~U[2025-10-26 14:22:00Z]}

      assert {:ok, %Visit{} = visit} = Tracking.update_visit(visit, update_attrs)
      assert visit.url == "some updated url"
      assert visit.visited_at == ~U[2025-10-26 14:22:00Z]
    end

    test "update_visit/2 with invalid data returns error changeset" do
      visit = visit_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracking.update_visit(visit, @invalid_attrs)
      assert visit == Tracking.get_visit!(visit.id)
    end

    test "delete_visit/1 deletes the visit" do
      visit = visit_fixture()
      assert {:ok, %Visit{}} = Tracking.delete_visit(visit)
      assert_raise Ecto.NoResultsError, fn -> Tracking.get_visit!(visit.id) end
    end

    test "change_visit/1 returns a visit changeset" do
      visit = visit_fixture()
      assert %Ecto.Changeset{} = Tracking.change_visit(visit)
    end
  end
end
