defmodule ValidateTest.Rules.MinDigitsTest do
  use ExUnit.Case
  doctest Validate.Rules.MinDigits

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: 3
  }

  @error {:error, "must be at least 3 digits long"}

  test "when number is the right amount of digits" do
    assert Validate.Rules.MinDigits.validate(%{@input | value: 100}) == success(100)
  end

  test "when number is less than provided digit length" do
    assert Validate.Rules.MinDigits.validate(%{@input | value: 10}) == @error
  end

  test "when number is greater than provided digit length" do
    assert Validate.Rules.MinDigits.validate(%{@input | value: 1000}) == success(1000)
  end
end
