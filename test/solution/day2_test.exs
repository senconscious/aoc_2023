defmodule Solution.Day2Test do
  use ExUnit.Case, async: true

  alias Solution.Day2

  test "sums appropriate game ids" do
    assert 8 == Day2.sum_appropriate_game_ids("test/support/inputs/day2_half1")
  end
end
