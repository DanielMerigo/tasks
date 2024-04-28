defmodule Tasks.TaskManagement.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :completed, :boolean, default: false
    field :description, :string
    field :due_date, :date
    field :name, :string
    field :priority, :string
    field :user_id, :id
    field :status, Ecto.Enum, values: [:completed, :available, :running], default: :available

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :description, :completed, :priority, :due_date, :status])
    |> validate_required([:name, :description, :completed, :priority, :due_date, :status])
  end
end
