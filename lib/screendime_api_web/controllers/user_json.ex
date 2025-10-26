defmodule ScreendimeApiWeb.UserJSON do
  alias ScreendimeApi.Users.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      balance: user.balance,
      stake: user.stake,
      joined: user.joined,
      recharges_on: user.recharges_on,
      last_penalty: user.last_penalty
    }
  end
end
