defmodule Solution.Day1 do
  @moduledoc """
  Provides utility to calculate calibration value
  """

  @path "priv/inputs/day1"

  @pattern ~r/\d/

  def calculate_value(path \\ @path) do
    path
    |> File.stream!()
    |> Stream.map(&first_last_digits_tuple/1)
    |> Enum.reduce(0, &to_number/2)
  end

  defp first_last_digits_tuple(string) when is_binary(string) do
    occurences =
      string
      |> replace_letter_digits()
      |> then(&Regex.scan(@pattern, &1))

    {first(occurences), last(occurences)}
  end

  defp replace_letter_digits("one" <> rest), do: "1" <> replace_letter_digits("e" <> rest)
  defp replace_letter_digits("two" <> rest), do: "2" <> replace_letter_digits("o" <> rest)
  defp replace_letter_digits("three" <> rest), do: "3" <> replace_letter_digits("e" <> rest)
  defp replace_letter_digits("four" <> rest), do: "4" <> replace_letter_digits("r" <> rest)
  defp replace_letter_digits("five" <> rest), do: "5" <> replace_letter_digits("e" <> rest)
  defp replace_letter_digits("six" <> rest), do: "6" <> replace_letter_digits("x" <> rest)
  defp replace_letter_digits("seven" <> rest), do: "7" <> replace_letter_digits("n" <> rest)
  defp replace_letter_digits("eight" <> rest), do: "8" <> replace_letter_digits("t" <> rest)
  defp replace_letter_digits("nine" <> rest), do: "9" <> replace_letter_digits("e" <> rest)
  defp replace_letter_digits(<<char, rest::binary>>), do: <<char>> <> replace_letter_digits(rest)
  defp replace_letter_digits(""), do: ""

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

  defp to_integer([digit]) do
    String.to_integer(digit)
  end

  defp to_number({first, last}, acc) when is_integer(first) and is_integer(last) do
    acc + first * 10 + last
  end
end
