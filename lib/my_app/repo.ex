defmodule MyApp.Repo do
  # use Ecto.Repo,
  #   otp_app: :my_app,
  #   adapter: Ecto.Adapters.Postgres

  use AshPostgres.Repo, otp_app: :my_app

  def installed_extensions do
    ["ash-functions", "uuid-ossp", "citext"]
  end
end
