defmodule ScreendimeApi.BlockingTest do
  use ScreendimeApi.DataCase

  alias ScreendimeApi.Blocking

  describe "blocked_patterns" do
    alias ScreendimeApi.Blocking.BlockedPattern

    import ScreendimeApi.BlockingFixtures

    @invalid_attrs %{pattern: nil}

    test "list_blocked_patterns/0 returns all blocked_patterns" do
      blocked_pattern = blocked_pattern_fixture()
      assert Blocking.list_blocked_patterns() == [blocked_pattern]
    end

    test "get_blocked_pattern!/1 returns the blocked_pattern with given id" do
      blocked_pattern = blocked_pattern_fixture()
      assert Blocking.get_blocked_pattern!(blocked_pattern.id) == blocked_pattern
    end

    test "create_blocked_pattern/1 with valid data creates a blocked_pattern" do
      valid_attrs = %{pattern: "some pattern"}

      assert {:ok, %BlockedPattern{} = blocked_pattern} = Blocking.create_blocked_pattern(valid_attrs)
      assert blocked_pattern.pattern == "some pattern"
    end

    test "create_blocked_pattern/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blocking.create_blocked_pattern(@invalid_attrs)
    end

    test "update_blocked_pattern/2 with valid data updates the blocked_pattern" do
      blocked_pattern = blocked_pattern_fixture()
      update_attrs = %{pattern: "some updated pattern"}

      assert {:ok, %BlockedPattern{} = blocked_pattern} = Blocking.update_blocked_pattern(blocked_pattern, update_attrs)
      assert blocked_pattern.pattern == "some updated pattern"
    end

    test "update_blocked_pattern/2 with invalid data returns error changeset" do
      blocked_pattern = blocked_pattern_fixture()
      assert {:error, %Ecto.Changeset{}} = Blocking.update_blocked_pattern(blocked_pattern, @invalid_attrs)
      assert blocked_pattern == Blocking.get_blocked_pattern!(blocked_pattern.id)
    end

    test "delete_blocked_pattern/1 deletes the blocked_pattern" do
      blocked_pattern = blocked_pattern_fixture()
      assert {:ok, %BlockedPattern{}} = Blocking.delete_blocked_pattern(blocked_pattern)
      assert_raise Ecto.NoResultsError, fn -> Blocking.get_blocked_pattern!(blocked_pattern.id) end
    end

    test "change_blocked_pattern/1 returns a blocked_pattern changeset" do
      blocked_pattern = blocked_pattern_fixture()
      assert %Ecto.Changeset{} = Blocking.change_blocked_pattern(blocked_pattern)
    end
  end
end
