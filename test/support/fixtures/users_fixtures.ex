defmodule ScreendimeApi.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ScreendimeApi.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        balance: 42,
        joined: ~U[2025-10-25 06:42:00Z],
        last_penalty: ~U[2025-10-25 06:42:00Z],
        recharges_on: ~U[2025-10-25 06:42:00Z],
        stake: 42
      })
      |> ScreendimeApi.Users.create_user()

    user
  end
end
