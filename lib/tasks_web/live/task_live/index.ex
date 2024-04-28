defmodule TasksWeb.TaskLive.Index do
  use TasksWeb, :live_view

  alias Tasks.TaskManagement
  alias Tasks.TaskManagement.Task

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :tasks, TaskManagement.list_tasks())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("toggle_row", %{"id" => id}, socket) do
    task = TaskManagement.get_task!(id)

    TaskManagement.update_task(task, %{completed: not task.completed})

    {:noreply, socket}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:task, TaskManagement.get_task!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Task")
    |> assign(:task, %Task{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tasks")
    |> assign(:task, nil)
  end

  @impl true
  def handle_info({TasksWeb.TaskLive.FormComponent, {:saved, task}}, socket) do
    {:noreply, stream_insert(socket, :tasks, task)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    task = TaskManagement.get_task!(id)
    {:ok, _} = TaskManagement.delete_task(task)

    {:noreply, stream_delete(socket, :tasks, task)}
  end
end
