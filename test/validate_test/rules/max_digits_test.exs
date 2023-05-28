defmodule ValidateTest.Rules.MaxDigitsTest do
  use ExUnit.Case
  doctest Validate.Rules.MaxDigits

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: 3
  }

  @error {:error, "must be at most 3 digits long"}

  test "it can be called from validate" do
    assert Validate.validate(10, max_digits: 10) == success(10)
  end

  test "when number is the right amount of digits" do
    assert Validate.Rules.MaxDigits.validate(%{@input | value: 100}) == success(100)
  end

  test "when number is less than provided digit length" do
    assert Validate.Rules.MaxDigits.validate(%{@input | value: 10}) == success(10)
  end

  test "when number is greater than provided digit length" do
    assert Validate.Rules.MaxDigits.validate(%{@input | value: 1000}) == @error
  end
end
