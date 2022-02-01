defmodule CsvTest.PlayerSeasonsTest do
  use CsvTest.RepoCase

  alias CsvTest.PlayerSeason
  alias CsvTest.PlayerSeasons

  describe "populate_people_table_from_csv(file)" do
    test "when all entries in csv_files are valid, should populate successfully" do
      assert PlayerSeasons.populate_people_table_from_csv("players_seasons.csv") == :ok

      assert Repo.one(from(p in PlayerSeason, select: count())) == 40953
    end
  end
end
