defmodule ScreendimeApiWeb.VisitJSON do
  alias ScreendimeApi.Tracking.Visit

  @doc """
  Renders a list of visits.
  """
  def index(%{visits: visits}) do
    %{data: for(visit <- visits, do: data(visit))}
  end

  @doc """
  Renders a single visit.
  """
  def show(%{visit: visit}) do
    %{data: data(visit)}
  end

  defp data(%Visit{} = visit) do
    %{
      id: visit.id,
      url: visit.url,
      visited_at: visit.visited_at
    }
  end
end
