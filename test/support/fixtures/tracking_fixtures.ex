defmodule ScreendimeApi.TrackingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ScreendimeApi.Tracking` context.
  """

  @doc """
  Generate a visit.
  """
  def visit_fixture(attrs \\ %{}) do
    {:ok, visit} =
      attrs
      |> Enum.into(%{
        url: "some url",
        visited_at: ~U[2025-10-25 14:22:00Z]
      })
      |> ScreendimeApi.Tracking.create_visit()

    visit
  end
end
