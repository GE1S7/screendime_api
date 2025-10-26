defmodule ScreendimeApi.Repo.Migrations.AddUsersTimezone do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :timezone, :string
    end
  end
end
