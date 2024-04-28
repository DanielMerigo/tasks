defmodule TasksWeb.PageController do
  use TasksWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    user = conn.assigns.current_user

    case user do
      nil ->
        conn
        |> redirect(to: ~p"/users/log_in")

      _ ->
        conn
        |> assign(:user, user)
        |> redirect(to: ~p"/tasks")
    end
  end
end
