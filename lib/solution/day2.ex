defmodule Solution.Day2 do
  @path "priv/inputs/day2"

  @bag %{
    red: 12,
    green: 13,
    blue: 14
  }

  @game_pattern ~r/(\d+) (red|green|blue)/

  @colors ["red", "green", "blue"]

  @atom_colors Enum.map(@colors, &String.to_existing_atom/1)

  def sum_appropriate_game_ids(path \\ @path) do
    path
    |> File.stream!()
    |> Stream.map(&parse_line/1)
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

  def power_set(path \\ @path) do
    path
    |> File.stream!()
    |> Stream.map(&parse_line/1)
    |> Stream.filter(&valid_game?/1)
    |> Stream.map(&min_rolls/1)
    |> Stream.map(&game_power_set/1)
    |> Enum.reduce(&sum_power_sets/2)
  end

  defp valid_game?({_id, _games}), do: true

  defp valid_game?(_), do: false

  defp min_rolls({_id, games}) do
    Enum.reduce(games, &min_roll/2)
  end

  defp min_roll(game, acc) do
    for key <- @atom_colors, into: %{} do
      current_value = Map.get(acc, key, 0)
      game_value = Map.get(game, key, 0)

      if game_value > current_value do
        {key, game_value}
      else
        {key, current_value}
      end
    end
  end

  defp game_power_set(game) do
    Enum.reduce(game, 1, fn {_key, value}, acc -> acc * value end)
  end

  defp sum_power_sets(number, acc), do: number + acc
end
