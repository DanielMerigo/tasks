defmodule Tasks.TaskManagementFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Tasks.TaskManagement` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        completed: true,
        description: "some description",
        due_date: ~D[2024-04-27],
        name: "some name",
        priority: "some priority"
      })
      |> Tasks.TaskManagement.create_task()

    task
  end
end
