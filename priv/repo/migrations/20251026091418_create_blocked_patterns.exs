defmodule ScreendimeApi.Repo.Migrations.CreateBlockedPatterns do
  use Ecto.Migration

  def change do
    create table(:blocked_patterns) do
      add :pattern, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:blocked_patternsw, [:user_id])
  end
end
