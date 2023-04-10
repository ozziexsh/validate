defmodule ValidateTest.Rules.BetweenTest do
  use ExUnit.Case
  doctest Validate.Rules.Between

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: {1, 10}
  }

  @error {:error, "must be between 1 and 10"}

  test "when number is lower bound" do
    assert Validate.Rules.Between.validate(%{@input | value: 1}) == success(1)
  end

  test "when number is upper bound" do
    assert Validate.Rules.Between.validate(%{@input | value: 10}) == success(10)
  end

  test "when number is between lower and upper bound" do
    assert Validate.Rules.Between.validate(%{@input | value: 8}) == success(8)
  end

  test "when number is lower than lower bound" do
    assert Validate.Rules.Between.validate(%{@input | value: 0}) == @error
  end

  test "when number is higher than upper bound" do
    assert Validate.Rules.Between.validate(%{@input | value: 11}) == @error
  end
end
