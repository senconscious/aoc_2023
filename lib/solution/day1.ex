defmodule Solution.Day1 do
  @moduledoc """
  Provides utility to calculate calibration value
  """

  @path "priv/inputs/day1"

  @string_digits for integer <- 1..9, do: Integer.to_string(integer)

  @word_digits ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

  @word_digits_map @word_digits |> Enum.with_index(1) |> Map.new()

  @pattern ~r/\d|one|two|three|four|five|six|seven|eight|nine/

  def calculate_value(path \\ @path) do
    path
    |> File.stream!()
    |> Stream.map(&first_last_digits_tuple/1)
    |> Enum.reduce(0, &to_number/2)
  end

  defp first_last_digits_tuple(string) when is_binary(string) do
    IO.inspect(string, label: "Input string")
    occurences = Regex.scan(@pattern, string)

    {first(occurences), last(occurences)}
    |> IO.inspect(label: "Output string")
  end

  defp first(occurences) do
    occurences
    |> List.first()
    |> to_integer()
  end

  defp last(occurences) do
    occurences
    |> List.last()
    |> to_integer()
  end

  defp to_integer([digit]) when digit in @string_digits do
    String.to_integer(digit)
  end

  defp to_integer([digit]) when digit in @word_digits do
    Map.fetch!(@word_digits_map, digit)
  end

  defp to_number({first, last}, acc) when is_integer(first) and is_integer(last) do
    acc + first * 10 + last
  end
end
