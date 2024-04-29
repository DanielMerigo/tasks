defmodule TasksWeb.UserLoginLive do
  use TasksWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="min-h-screen min-w-full p-32 bg-dark_gray">
      <div class="mx-auto max-w-md bg-red p-6 rounded-lg shadow-lg bg-light_gray">
        <.header class="text-center">
          <span class="text-off_white">
            Log in to account
          </span>
          <:subtitle>
            <span class="text-off_white">
              Don't have an account?
            </span>
            <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
              Sign up
            </.link>
            <span class="text-off_white">
              for an account now.
            </span>
          </:subtitle>
        </.header>

        <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
          <.input field={@form[:email]} type="email" label="Email" required />
          <.input field={@form[:password]} type="password" label="Password" required />

          <:actions>
            <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
            <.link href={~p"/users/reset_password"} class="text-sm font-semibold text-off_white">
              Forgot your password?
            </.link>
          </:actions>
          <:actions>
            <.button phx-disable-with="Logging in..." class="w-full">
              Log in <span aria-hidden="true">→</span>
            </.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
