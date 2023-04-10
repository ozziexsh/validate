defmodule ValidateTest.Rules.DigitsBetweenTest do
  use ExUnit.Case
  doctest Validate.Rules.DigitsBetween

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: {2, 4}
  }

  @error {:error, "must be between 2 and 4 digits"}

  test "when number is lower bound" do
    assert Validate.Rules.DigitsBetween.validate(%{@input | value: 10}) == success(10)
  end

  test "when number is upper bound" do
    assert Validate.Rules.DigitsBetween.validate(%{@input | value: 1000}) == success(1000)
  end

  test "when number is between lower and upper bound" do
    assert Validate.Rules.DigitsBetween.validate(%{@input | value: 100}) == success(100)
  end

  test "when number is lower than lower bound" do
    assert Validate.Rules.DigitsBetween.validate(%{@input | value: 5}) == @error
  end

  test "when number is higher than upper bound" do
    assert Validate.Rules.DigitsBetween.validate(%{@input | value: 10000}) == @error
  end
end
