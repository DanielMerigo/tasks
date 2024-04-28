defmodule TasksWeb.UserRegistrationLive do
  use TasksWeb, :live_view

  alias Tasks.Users
  alias Tasks.Users.User

  def render(assigns) do
    ~H"""
    <div class="min-h-screen min-w-full p-32 bg-dark_gray">
      <div class="mx-auto max-w-md bg-red p-6 rounded-lg shadow-lg bg-light_gray">
        <.header class="text-center">
          <span class="text-off_white">
            Register for an account
          </span>
          <:subtitle>
            <span class="text-off_white">
              Already registered?
            </span>
            <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
              Log in
            </.link>
            <span class="text-off_white">
              to your account now.
            </span>
          </:subtitle>
        </.header>

        <.simple_form
          for={@form}
          id="registration_form"
          phx-submit="save"
          phx-change="validate"
          phx-trigger-action={@trigger_submit}
        >
          <.error :if={@check_errors}>
            Oops, something went wrong! Please check the errors below.
          </.error>

          <div class="flex justify-between">
            <.input field={@form[:first_name]} type="text" label="First Name" required />
            <.input field={@form[:last_name]} type="text" label="Last Name" required />
          </div>

          <.input field={@form[:email]} type="email" label="Email" required />
          <.input field={@form[:password]} type="password" label="Password" required />

          <:actions>
            <.button phx-disable-with="Creating account..." class="w-full">Create an account</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Users.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Users.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Users.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Users.change_user_registration(user)

        socket =
          socket
          |> assign(trigger_submit: false)
          |> assign_form(changeset)
          |> put_flash(:info, "Account created successfully. Please check your email to confirm your account.")
          |> push_navigate(to: ~p"/users/log_in")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Users.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
