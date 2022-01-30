import Config

config :csv_test, CsvTest.Repo,
  database: "csv_test_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :csv_test, ecto_repos: [CsvTest.Repo]
