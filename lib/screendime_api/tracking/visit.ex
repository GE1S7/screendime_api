defmodule ScreendimeApi.Tracking.Visit do
  use Ecto.Schema
  import Ecto.Changeset

  require Tzdata


  schema "visits" do
    field :url, :string

    # internal fields
    field :visited_at, :utc_datetime
    field :timezone, :string

    belongs_to :user, ScreendimeApi.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(visit, attrs) do
    visit
    |> cast(attrs, [:user_id, :url, :visited_at, :timezone])
    |> validate_required([:user_id, :url, :visited_at, :timezone])
    |> validate_timezone()
    |> set_timestamp()
  end


  def validate_timezone(cs) do
    timezone = get_change(cs, :timezone)
    if Tzdata.canonical_zone?(timezone) do
      cs
    else
      add_error(cs, :timezone, "invalid")
    end
  end

  def set_timestamp(cs) do
    visited_at = DateTime.utc_now() |> DateTime.truncate(:second)

    cs
    |>put_change(:visited_at, visited_at)

  end


end
