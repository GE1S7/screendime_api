defmodule ScreendimeApiWeb.PageController do
  use ScreendimeApiWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
