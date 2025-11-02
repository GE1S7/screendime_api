defmodule ScreendimeApi.Blocking do
  @moduledoc """
  The Blocking context.
  """

  import Ecto.Query, warn: false

  alias ScreendimeApi.Repo

  alias ScreendimeApi.Blocking.BlockedPattern

  alias ScreendimeApi.Users.User
  require Wildcard


  @doc """
  Returns the list of blocked_patterns.

  ## Examples

      iex> list_blocked_patterns()
      [%BlockedPattern{}, ...]

  """
  def list_blocked_patterns(user_id) do
    BlockedPattern
    |> where(user_id: ^user_id)
    |> Repo.all()
  end

  @doc """
  Gets a single blocked_pattern.

  Raises `Ecto.NoResultsError` if the Blocked pattern does not exist.

  ## Examples

      iex> get_blocked_pattern!(123)
      %BlockedPattern{}

      iex> get_blocked_pattern!(456)
      ** (Ecto.NoResultsError)

  """
  def get_blocked_pattern!(id), do: Repo.get!(BlockedPattern, id)

  @doc """
  Creates a blocked_pattern.

  ## Examples

      iex> create_blocked_pattern(%{field: value})
      {:ok, %BlockedPattern{}}

      iex> create_blocked_pattern(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_blocked_pattern(attrs) do
    %BlockedPattern{}
    |> BlockedPattern.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a blocked_pattern.

  ## Examples

      iex> update_blocked_pattern(blocked_pattern, %{field: new_value})
      {:ok, %BlockedPattern{}}

      iex> update_blocked_pattern(blocked_pattern, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_blocked_pattern(%BlockedPattern{} = blocked_pattern, attrs) do
    blocked_pattern
    |> BlockedPattern.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a blocked_pattern.

  ## Examples

      iex> delete_blocked_pattern(blocked_pattern)
      {:ok, %BlockedPattern{}}

      iex> delete_blocked_pattern(blocked_pattern)
      {:error, %Ecto.Changeset{}}

  """
  def delete_blocked_pattern(%BlockedPattern{} = blocked_pattern) do
    Repo.delete(blocked_pattern)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking blocked_pattern changes.

  ## Examples

      iex> change_blocked_pattern(blocked_pattern)
      %Ecto.Changeset{data: %BlockedPattern{}}

  """
  def change_blocked_pattern(%BlockedPattern{} = blocked_pattern, attrs \\ %{}) do
    BlockedPattern.changeset(blocked_pattern, attrs)
  end

 def is_url_blocked?(%User{} = user, url_to_check) do
    clean_url =
      url_to_check
      |> String.split("://")
      |> List.last()
      |> String.split("www")
      |> List.last()

    patterns = user.blocked_patterns

    Enum.any?(patterns, fn pattern ->
      Wildcard.matches?(clean_url, pattern.url)
    end)
  end
end
