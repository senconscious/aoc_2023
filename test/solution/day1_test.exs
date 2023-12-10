defmodule Solution.Day1Test do
  use ExUnit.Case, async: true

  alias Solution.Day1

  test "calculates calibrator" do
    assert 142 = Day1.calculate_value("test/support/inputs/day1")
  end
end
