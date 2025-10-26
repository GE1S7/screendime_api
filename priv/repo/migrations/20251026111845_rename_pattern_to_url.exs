defmodule ScreendimeApi.Repo.Migrations.RenamePatternToUrl do
  use Ecto.Migration

  def change do
    rename table(:blocked_patterns), :pattern, to: :url
  end
end
