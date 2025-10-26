defmodule ScreendimeApi.Tracking do
  @moduledoc """
  The Tracking context.
  """

  import Ecto.Query, warn: false
  alias ScreendimeApi.Repo

  alias ScreendimeApi.Tracking.Visit

  @doc """
  Returns the list of visits for a specific user.

  ## Examples

      iex> list_visits_for_user(1)
      [%Visit{}, ...]

  """
  def list_visits_for_user(user_id) do
    Visit
    |> where([v], v.user_id == ^user_id)
    |> Repo.all()
  end

  @doc """
  Gets a single visit for a specific user.

  Raises `Ecto.NoResultsError` if the Visit does not exist or does not belong to the user.

  ## Examples

      iex> get_visit_for_user!(1, 123)
      %Visit{}

      iex> get_visit_for_user!(1, 456)
      ** (Ecto.NoResultsError)

  """
  def get_visit_for_user!(user_id, id) do
    Visit
    |> where([v], v.user_id == ^user_id and v.id == ^id)
    |> Repo.one!()
  end

  @doc """
  Creates a visit.

  ## Examples

      iex> create_visit(%{field: value})
      {:ok, %Visit{}}

      iex> create_visit(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_visit(attrs) do
    %Visit{}
    |> Visit.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a visit.

  ## Examples

      iex> update_visit(visit, %{field: new_value})
      {:ok, %Visit{}}

      iex> update_visit(visit, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_visit(%Visit{} = visit, attrs) do
    visit
    |> Visit.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a visit.

  ## Examples

      iex> delete_visit(visit)
      {:ok, %Visit{}}

      iex> delete_visit(visit)
      {:error, %Ecto.Changeset{}}

  """
  def delete_visit(%Visit{} = visit) do
    Repo.delete(visit)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking visit changes.

  ## Examples

      iex> change_visit(visit)
      %Ecto.Changeset{data: %Visit{}}

  """
  def change_visit(%Visit{} = visit, attrs \\ %{}) do
    Visit.changeset(visit, attrs)
  end
end
