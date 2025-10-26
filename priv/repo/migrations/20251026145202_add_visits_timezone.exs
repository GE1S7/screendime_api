defmodule ScreendimeApi.Repo.Migrations.AddVisitsTimezone do
  use Ecto.Migration

  def change do
    alter table(:visits) do
      add :timezone, :string
    end
  end
end
