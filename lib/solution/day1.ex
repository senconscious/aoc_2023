defmodule Solution.Day1 do
  @moduledoc """
  Provides utility to calculate calibration value
  """

  @path "priv/inputs/day1"

  def calculate_value(path \\ @path) do
    path
    |> File.stream!()
    |> Stream.map(&first_last_digits_tuple/1)
    |> Enum.reduce(0, &to_number/2)
  end

  defp first_last_digits_tuple(string) when is_binary(string) do
    occurences = Regex.scan(~r/\d/, string)

    {first(occurences), last(occurences)}
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

  defp to_integer([digit]) when is_binary(digit) do
    String.to_integer(digit)
  end

  defp to_number({first, last}, acc) when is_integer(first) and is_integer(last) do
    acc + first * 10 + last
  end
end
