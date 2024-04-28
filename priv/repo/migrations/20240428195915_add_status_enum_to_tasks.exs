defmodule Tasks.Repo.Migrations.AddStatusEnumToTasks do
  use Ecto.Migration

  def up do
    execute "CREATE TYPE task_status AS ENUM ('completed', 'available', 'running')"

    alter table(:tasks) do
      add :status, :task_status, default: "available", null: false
    end
  end

  def down do
    alter table(:tasks) do
      remove :status
    end

    execute "DROP TYPE task_status"
  end
end
