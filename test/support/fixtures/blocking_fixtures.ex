defmodule ScreendimeApi.BlockingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ScreendimeApi.Blocking` context.
  """

  @doc """
  Generate a blocked_pattern.
  """
  def blocked_pattern_fixture(attrs \\ %{}) do
    {:ok, blocked_pattern} =
      attrs
      |> Enum.into(%{
        pattern: "some pattern"
      })
      |> ScreendimeApi.Blocking.create_blocked_pattern()

    blocked_pattern
  end
end
