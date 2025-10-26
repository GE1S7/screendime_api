defmodule ScreendimeApiWeb.BlockedPatternJSON do
  alias ScreendimeApi.Blocking.BlockedPattern

  @doc """
  Renders a list of blocked_patterns.
  """
  def index(%{blocked_patterns: blocked_patterns}) do
    %{data: for(blocked_pattern <- blocked_patterns, do: data(blocked_pattern))}
  end

  @doc """
  Renders a single blocked_pattern.
  """
  def show(%{blocked_pattern: blocked_pattern}) do
    %{data: data(blocked_pattern)}
  end

  defp data(%BlockedPattern{} = blocked_pattern) do
    %{
      id: blocked_pattern.id,
      pattern: blocked_pattern.url
    }
  end
end
