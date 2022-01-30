defmodule CsvTest.PlayerSeason do
  @moduledoc """
  Defines the Player Season schema.
  """
  use Ecto.Schema

  schema "player_season" do
    field(:total_seniors, :map)
    field(:club_seniors, :map)
    field(:national_team_seniors, :map)
    field(:club_youth_honours, :map)
    field(:national_team_youth_honours, :map)
    field(:career_stats, {:array, :map})
    field(:player_id, :string)
    field(:club_id, :string)
  end
end
