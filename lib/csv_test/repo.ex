defmodule CsvTest.Repo do
  use Ecto.Repo,
    otp_app: :csv_test,
    adapter: Ecto.Adapters.Postgres
end
