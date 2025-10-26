defmodule ScreendimeApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :balance, :integer
      add :stake, :integer
      add :joined, :utc_datetime
      add :recharges_on, :utc_datetime
      add :last_penalty, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
