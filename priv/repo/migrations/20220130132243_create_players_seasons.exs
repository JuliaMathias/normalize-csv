defmodule CsvTest.Repo.Migrations.CreatePlayersSeasons do
  use Ecto.Migration

  def change do
    create table(:players_seasons) do
      add :total_seniors, :map
      add :club_seniors, :map
      add :national_team_seniors, :map
      add :club_youth_honours, :map
      add :national_team_youth_honours, :map,
      add :career_stats, :array
      add :player_id, :string
      add :club_id, :string
    end
  end
end
