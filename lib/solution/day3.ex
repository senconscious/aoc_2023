defmodule Solution.Day3 do
  @path "priv/inputs/day3"

  @digits for digit <- 0..9, do: Integer.to_string(digit)

  def engine_number(path \\ @path) do
    Process.put(:numbers, [])
    Process.put(:symbols, [])

    path
    |> File.stream!()
    |> Stream.with_index()
    |> Stream.map(&parse_line/1)
    |> Stream.run()

    :numbers
    |> Process.get()
    |> Stream.filter(&has_symbol?/1)
    |> Enum.reduce(0, &sum_numbers/2)
  end

  defp parse_line({line, index}) do
    line
    |> String.graphemes()
    |> Stream.with_index()
    |> Stream.map(&grapheme_with_meta(&1, index))
    |> Enum.reduce(%{current_number: nil, current_number_start_index: nil}, &save_number_symbol/2)
  end

  defp grapheme_with_meta({grapheme, column_index}, row_index) do
    {grapheme, row_index, column_index}
  end

  defp save_number_symbol({grapheme, _row_index, column_index}, acc) when grapheme in @digits do
    case Map.get(acc, :current_number) do
      nil ->
        Map.merge(acc, %{
          current_number: String.to_integer(grapheme),
          current_number_start_index: column_index
        })

      number ->
        Map.put(acc, :current_number, number * 10 + String.to_integer(grapheme))
    end
  end

  defp save_number_symbol({grapheme, row_index, column_index}, acc) do
    acc
    |> maybe_save_symbol(grapheme, row_index, column_index)
    |> maybe_save_number(row_index, column_index)
  end

  defp maybe_save_symbol(acc, grapheme, _row_index, _column_index) when grapheme in [".", "\n"] do
    acc
  end

  defp maybe_save_symbol(acc, _grapheme, row_index, column_index) do
    save_symbol(row_index, column_index)
    acc
  end

  defp maybe_save_number(%{current_number: nil} = acc, _row_index, _column_index), do: acc

  defp maybe_save_number(acc, row_index, column_index) do
    left_border = Map.fetch!(acc, :current_number_start_index)
    number = Map.fetch!(acc, :current_number)

    save_number(number, row_index, left_border, column_index - 1)

    %{current_number: nil, current_number_start_index: nil}
  end

  defp save_symbol(row_index, column_index) do
    :symbols
    |> Process.get()
    |> then(&Process.put(:symbols, [{row_index, column_index} | &1]))
  end

  defp save_number(number, row_index, left_border, right_border) do
    :numbers
    |> Process.get()
    |> then(&Process.put(:numbers, [{number, row_index, left_border, right_border} | &1]))

    :ok
  end

  defp has_symbol?({_number, row_index, left_border, right_border}) do
    :symbols
    |> Process.get()
    |> Enum.any?(&adjacent?(&1, row_index, left_border, right_border))
  end

  defp adjacent?(
         {symbol_row_index, symbol_column_index},
         number_row_index,
         number_left_index,
         number_right_index
       ) do
    adjacent_vertically?(symbol_row_index, number_row_index) and
      adjacent_left?(symbol_column_index, number_left_index) and
      adjacent_right?(symbol_column_index, number_right_index)
  end

  defp adjacent_vertically?(symbol_index, number_index) do
    symbol_index >= number_index - 1 and symbol_index <= number_index + 1
  end

  defp adjacent_left?(symbol_index, number_index) do
    symbol_index >= number_index - 1
  end

  defp adjacent_right?(symbol_index, number_index) do
    symbol_index <= number_index + 1
  end

  defp sum_numbers({number, _row_index, _left_border, _right_border}, acc), do: number + acc

  def gear_ratio(path \\ @path) do
    Process.put(:numbers, [])
    Process.put(:symbols, [])

    path
    |> File.stream!()
    |> Stream.with_index()
    |> Stream.map(&parse_line/1)
    |> Stream.run()

    :symbols
    |> Process.get()
    |> Stream.map(&adjacent_numbers/1)
    |> Stream.filter(&two_adjacent_numbers?/1)
    |> Stream.map(&multiply_adjacent_numbers/1)
    |> Enum.reduce(0, &sum_gear/2)
  end

  defp adjacent_numbers(symbol) do
    :numbers
    |> Process.get()
    |> Stream.filter(fn {_number, row_index, left_index, right_index} ->
      adjacent?(symbol, row_index, left_index, right_index)
    end)
    |> Enum.map(fn {number, _, _, _} -> number end)
  end

  defp two_adjacent_numbers?(numbers) do
    Enum.count(numbers) == 2
  end

  defp multiply_adjacent_numbers([first, second]) do
    first * second
  end

  defp sum_gear(number, acc), do: acc + number
end
