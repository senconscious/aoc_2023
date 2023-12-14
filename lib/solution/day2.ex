defmodule Solution.Day2 do
  @path "priv/inputs/day2"

  @bag %{
    red: 12,
    green: 13,
    blue: 14
  }

  @game_pattern ~r/(\d+) (red|green|blue)/

  @colors ["red", "green", "blue"]

  def sum_appropriate_game_ids(path \\ @path) do
    path
    |> File.stream!()
    |> Stream.map(&parse_line/1)
    |> Stream.map(&IO.inspect/1)
    |> Stream.filter(&appropriate_games?/1)
    |> Enum.reduce(0, &sum_ids/2)
  end

  defp parse_line(line) do
    case String.split(line, ":") do
      [raw_id, raw_games] ->
        {parse_game_id(raw_id), parse_games(raw_games)}

      _ ->
        :invalid_line
    end
  end

  defp parse_game_id("Game " <> id) do
    String.to_integer(id)
  end

  defp parse_games(raw_games) do
    raw_games
    |> String.split(";")
    |> Enum.map(&parse_game/1)
  end

  defp parse_game(raw_game) do
    @game_pattern
    |> Regex.scan(raw_game, capture: :all_but_first)
    |> Enum.reduce(%{}, &roll_to_map/2)
  end

  defp roll_to_map([number, color], acc) when color in @colors do
    Map.put(acc, String.to_existing_atom(color), String.to_integer(number))
  end

  defp appropriate_games?({_id, games}) do
    Enum.all?(games, &appropriate_game?/1)
  end

  defp appropriate_games?(_), do: false

  defp appropriate_game?(game) do
    Enum.all?(@bag, fn {key, value} ->
      Map.get(game, key, 0) <= value
    end)
  end

  defp sum_ids({id, _games}, acc) do
    acc + id
  end
end
