defmodule CsvTest.PlayerSeasons do
  @moduledoc """
  PlayerSeason context functions.
  """

  alias CsvTest.PlayerSeason

  def populate_people_table_from_csv(file) do
    File.stream!(file)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map_every(1, fn line -> String.split(line) end)
    |> Stream.map_every(1, fn element -> process_entry(element) end)
    |> Enum.to_list()
    |> Enum.filter(fn x -> x != :ok end)
    |> case do
      [] -> :ok
      list_of_errors -> list_of_errors
    end
  end

  defp process_entry(entry) do
    table_header =
      "total_seniors,club_seniors,national_teams_seniors,club_youth_honours,national_team_youth_honours,career_stats,player_id,club_id"

    readable_entry =
      entry
      |> List.to_string()
      |> String.replace("\"", "")
      |> String.replace_leading("{", "")
      |> String.replace_trailing(",", "")

    if readable_entry == table_header do
      :ok
    else
      [
        total_seniors,
        club_seniors,
        national_team_seniors,
        club_youth_honours | rest_of_columns
      ] = String.split(readable_entry, "},{")

      %PlayerSeason{
        total_seniors: normalize_map_entries(total_seniors),
        club_seniors: normalize_map_entries(club_seniors),
        national_team_seniors: normalize_map_entries(national_team_seniors),
        club_youth_honours: normalize_map_entries(club_youth_honours),
        national_team_youth_honours: get_national_team_honours(rest_of_columns),
        career_stats: get_career_stats(rest_of_columns),
        player_id: get_player_id(rest_of_columns),
        club_id: nil
      }
      |> CsvTest.Repo.insert()
      |> case do
        {:ok, _player_season} -> :ok
        error -> error
      end
    end
  end

  defp normalize_map_entries(entry) do
    if entry == "{}" or entry == "" do
      %{}
    else
      entry
      |> String.split(",")
      |> Enum.map(fn x -> String.split(x, "=>") end)
      |> Enum.map(fn [key, value] -> {String.to_atom(key), maybe_convert_to_integer(value)} end)
      |> Map.new()
    end
  end

  defp get_national_team_honours([first | _rest]),
    do: String.split(first, "},") |> List.first() |> normalize_map_entries()

  defp get_player_id(list) do
    list |> List.to_string() |> String.split(",") |> List.last()
  end

  defp get_career_stats(list) do
    cleaned_list =
      [get_first_career_stat(list)] ++
        get_middle_career_stats(list) ++ [get_last_career_stat(list)]

    cleaned_list
    |> Enum.map(fn x -> String.split(x, ",") end)
    |> Enum.map(fn x -> normalize_list(x) end)
    |> Enum.map(fn x -> list_to_merged_map(x) end)
  end

  defp normalize_list(list) do
    Enum.map(list, fn x -> normalize_map_entries(x) end)
  end

  defp get_first_career_stat([head | _tail]) do
    head
    |> String.split("},[")
    |> List.last()
    |> String.replace_leading("{", "")
  end

  defp get_middle_career_stats(list) do
    list
    |> Enum.drop(1)
    |> Enum.drop(-1)
  end

  defp get_last_career_stat(list) do
    list
    |> List.last()
    |> String.split("}],")
    |> Enum.drop(-1)
    |> List.last()
  end

  defp maybe_convert_to_integer(value) do
    cond do
      value == "-" ->
        0

      value == "" ->
        value

      String.length(value) <= 3 ->
        {new_value, _} = Integer.parse(value)
        new_value

      true ->
        value
    end
  end

  defp list_to_merged_map(list) do
    Enum.reduce(list, %{}, fn x, acc -> Map.merge(x, acc) end)
  end
end
