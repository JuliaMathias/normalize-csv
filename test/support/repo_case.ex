defmodule CsvTest.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias CsvTest.Repo

      import Ecto
      import Ecto.Query
      import CsvTest.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(CsvTest.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(CsvTest.Repo, {:shared, self()})
    end

    :ok
  end
end
