defmodule ScreendimeApi.Repo do
  use Ecto.Repo,
    otp_app: :screendime_api,
    adapter: Ecto.Adapters.SQLite3
end
