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
   params_with_user = Map.put(visit_params, "user_id", user_id)

    with {:ok, %Visit{} = visit} <- Tracking.create_visit(params_with_user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user_id}/visits/#{visit}")
      |> render(:show, visit: visit)
    end
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
