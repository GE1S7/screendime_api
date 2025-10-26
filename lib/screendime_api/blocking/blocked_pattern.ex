defmodule ScreendimeApi.Blocking.BlockedPattern do
  use Ecto.Schema
  import Ecto.Changeset

  schema "blocked_patterns" do
    field :url, :string
    #field :user_id, :id

    belongs_to :user, ScreendimeApi.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(blocked_pattern, attrs) do
    blocked_pattern
    |> cast(attrs, [:user_id, :url])
    |> validate_required([:user_id, :url])
    |> foreign_key_constraint(:user_id)
  end
end
