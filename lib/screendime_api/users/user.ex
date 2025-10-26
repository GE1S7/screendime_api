defmodule ScreendimeApi.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :balance, :integer
    field :stake, :integer

    # internal fields
    field :joined, :utc_datetime
    field :recharges_on, :utc_datetime
    field :last_penalty, :utc_datetime

    has_many :blocked_patterns, ScreendimeApi.Blocking.BlockedPattern

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:stake])
    |> validate_required([:stake])
    |> calculate_balance()
    |> set_timestamps()
  end

  def calculate_balance(cs) do
      stake = get_change(cs, :stake)
      if stake > 0 do
        put_change(cs, :balance, stake * 30)
      else
        add_error(cs, :stake, "empty")
      end

  end

  def set_timestamps(cs) do
    joined = DateTime.utc_now() |> DateTime.truncate(:second)
    recharges_on = DateTime.add(joined, 30, :day) |> DateTime.truncate(:second)

    cs
    |>put_change(:joined, joined)
    |>put_change(:recharges_on, recharges_on)


  end
end
