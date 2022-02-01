use Mix.Config

config :csv_test, CsvTest.Repo,
  username: "postgres",
  password: "postgres",
  database: "CsvTest_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
