defmodule ValidateTest.DigitsTest do
  use ExUnit.Case
  doctest Validate.Digits

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: 3
  }

  @error {:error, "must be exactly 3 digits long"}

  test "when number is the right amount of digits" do
    assert Validate.Digits.validate(%{@input | value: 100}) == success(100)
  end

  test "when number is less than provided digit length" do
    assert Validate.Digits.validate(%{@input | value: 10}) == @error
  end

  test "when number is greater than provided digit length" do
    assert Validate.Digits.validate(%{@input | value: 1000}) == @error
  end
end
