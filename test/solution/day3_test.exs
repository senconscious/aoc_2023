defmodule Solution.Day3Test do
  use ExUnit.Case, async: true

  alias Solution.Day3

  test "engine parts" do
    assert 4361 == Day3.engine_number("test/support/inputs/day3_half1")
  end

  test "gear ratio" do
    assert 467_835 == Day3.gear_ratio("test/support/inputs/day3_half1")
  end
end
