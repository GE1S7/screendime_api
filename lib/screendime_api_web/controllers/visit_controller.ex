defmodule ScreendimeApiWeb.VisitController do
  use ScreendimeApiWeb, :controller

  alias ScreendimeApi.Tracking
  alias ScreendimeApi.Tracking.Visit

  action_fallback ScreendimeApiWeb.FallbackController

  def index(conn, %{"user_id" => user_id}) do
    visits = Tracking.list_visits_for_user(user_id)
    render(conn, :index, visits: visits)
  end

  def create(conn, %{"user_id" => user_id, "visit" => visit_params}) do
    with {:ok, user} <- fetch_user_with_patterns(user_id),
         {:ok, url, timezone} <- get_visit_details(visit_params),
         :blocked <- check_if_blocked(user, url),
         :eligible <- check_penalty_eligibility(user, timezone) do

      updated_user = apply_penalty(user)

      conn
      |> put_status(:ok)
      |> json(%{
        status: "penalized",
        message: "Penalty applied for visiting a blocked site.",
        new_balance: updated_user.balance
      })
    else
      {:error, reason} ->
        conn |> put_status(:bad_request) |> json(%{error: reason})

      :not_blocked ->
        conn |> put_status(:ok) |> json(%{status: "allowed", message: "URL is not on the blocklist."})

      {:skipped, reason} ->
        conn |> put_status(:ok) |> json(%{status: "blocked_penalty_skipped", reason: reason})
    end
  end


defp fetch_user_with_patterns(user_id) do
  user =
    ScreendimeApi.Repo.get(ScreendimeApi.Users.User, user_id)
    |> ScreendimeApi.Repo.preload(:blocked_patterns)

  if user, do: {:ok, user}, else: {:error, "User not found"}
end

defp get_visit_details(params) do
  url = Map.get(params, "url")
  timezone = Map.get(params, "timezone")

  if url && timezone, do: {:ok, url, timezone}, else: {:error, "Missing url or timezone in request body"}
end

defp check_if_blocked(user, url) do
  if ScreendimeApi.Blocking.is_url_blocked?(user, url), do: :blocked, else: :not_blocked
end

defp check_penalty_eligibility(user, timezone) do
  cond do
    user.balance < user.stake ->
      {:skipped, "insufficient_balance"}

    user_fined_today?(user, timezone) ->
      {:skipped, "already_fined_today"}

    true ->
      :eligible
  end
end

defp user_fined_today?(user, visit_timezone) do
  case user.last_penalty do
    nil ->
      false
    last_penalty_utc ->
      last_penalty_local = Timex.to_datetime(last_penalty_utc, visit_timezone)
      start_of_today_local = Timex.today(visit_timezone)
      Timex.compare(last_penalty_local, start_of_today_local) >= 0
  end
end

defp apply_penalty(user) do
  user
  |> Ecto.Changeset.change(%{
    balance: user.balance - user.stake,
    last_penalty: DateTime.utc_now() |> DateTime.truncate(:second)
  })
  |> ScreendimeApi.Repo.update!()
end


 def show(conn, %{"user_id" => user_id, "id" => id}) do
    visit = Tracking.get_visit_for_user!(user_id, id)
    render(conn, :show, visit: visit)
  end

  def update(conn, %{"user_id" => user_id, "id" => id, "visit" => visit_params}) do
    visit = Tracking.get_visit_for_user!(user_id, id)

    with {:ok, %Visit{} = visit} <- Tracking.update_visit(visit, visit_params) do
      render(conn, :show, visit: visit)
    end
  end

  def delete(conn, %{"user_id" => user_id, "id" => id}) do
    visit = Tracking.get_visit_for_user!(user_id, id)
    with {:ok, %Visit{}} <- Tracking.delete_visit(visit) do
      send_resp(conn, :no_content, "")
    end
  end
end
