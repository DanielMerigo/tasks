defmodule Tasks.TaskManagementTest do
  use Tasks.DataCase

  alias Tasks.TaskManagement

  describe "tasks" do
    alias Tasks.TaskManagement.Task

    import Tasks.TaskManagementFixtures

    @invalid_attrs %{completed: nil, description: nil, due_date: nil, name: nil, priority: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert TaskManagement.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert TaskManagement.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{
        completed: true,
        description: "some description",
        due_date: ~D[2024-04-27],
        name: "some name",
        priority: "some priority"
      }

      assert {:ok, %Task{} = task} = TaskManagement.create_task(valid_attrs)
      assert task.completed == true
      assert task.description == "some description"
      assert task.due_date == ~D[2024-04-27]
      assert task.name == "some name"
      assert task.priority == "some priority"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TaskManagement.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()

      update_attrs = %{
        completed: false,
        description: "some updated description",
        due_date: ~D[2024-04-28],
        name: "some updated name",
        priority: "some updated priority"
      }

      assert {:ok, %Task{} = task} = TaskManagement.update_task(task, update_attrs)
      assert task.completed == false
      assert task.description == "some updated description"
      assert task.due_date == ~D[2024-04-28]
      assert task.name == "some updated name"
      assert task.priority == "some updated priority"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = TaskManagement.update_task(task, @invalid_attrs)
      assert task == TaskManagement.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = TaskManagement.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> TaskManagement.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = TaskManagement.change_task(task)
    end
  end
end
