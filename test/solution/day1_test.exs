defmodule Solution.Day1Test do
  use ExUnit.Case, async: true

  alias Solution.Day1

  test "calculates calibrator only digits" do
    assert 142 = Day1.calculate_value("test/support/inputs/day1_half1")
  end

  test "calculates calibrator not only digits" do
    assert 281 = Day1.calculate_value("test/support/inputs/day1_half2")
  end
end
