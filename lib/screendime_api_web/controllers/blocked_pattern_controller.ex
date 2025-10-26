defmodule ScreendimeApiWeb.BlockedPatternController do
  use ScreendimeApiWeb, :controller

  alias ScreendimeApi.Blocking
  alias ScreendimeApi.Blocking.BlockedPattern

  action_fallback ScreendimeApiWeb.FallbackController

  def index(conn, %{"user_id" => user_id}) do
    blocked_patterns = Blocking.list_blocked_patterns(user_id)
    render(conn, :index, blocked_patterns: blocked_patterns)
  end

  def create(conn, %{"user_id" => user_id, "blocked_pattern" => params}) do
    params = Map.put(params, "user_id", user_id)

    with {:ok, %BlockedPattern{} = blocked_pattern} <- Blocking.create_blocked_pattern(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user_id}/blocked-patterns/#{blocked_pattern}")
      |> render(:show, blocked_pattern: blocked_pattern)
    end
  end



  def show(conn, %{"user_id" => user_id, "id" => id}) do
    with {:ok, blocked_pattern} = get_user_pattern(user_id, id) do
    render(conn, :show, blocked_pattern: blocked_pattern)
    end
  end

  def update(conn, %{"user_id" => user_id, "id" => id, "blocked_pattern" => params}) do
    with {:ok, blocked_pattern} = get_user_pattern(user_id, id),
         {:ok, updated} <- Blocking.update_blocked_pattern(blocked_pattern, params) do
      render(conn, :show, blocked_pattern: updated)
    end
  end

  def delete(conn, %{"user_id" => user_id, "id" => id}) do
    with {:ok, blocked_pattern} = get_user_pattern(user_id, id),
         {:ok, _} <- Blocking.delete_blocked_pattern(blocked_pattern) do
      send_resp(conn, :no_content, "")
    end
  end

  defp get_user_pattern(user_id, id) do
    pattern = Blocking.get_blocked_pattern!(id)

    if pattern.user_id == String.to_integer(user_id) do
      {:ok, pattern}
    else
      {:error, :not_found}
    end
  end
end
