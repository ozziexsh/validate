defmodule ValidateTest.MaxDigitsTest do
  use ExUnit.Case
  doctest Validate.MaxDigits

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: 3
  }

  @error {:error, "must be at most 3 digits long"}

  test "when number is the right amount of digits" do
    assert Validate.MaxDigits.validate(%{@input | value: 100}) == success(100)
  end

  test "when number is less than provided digit length" do
    assert Validate.MaxDigits.validate(%{@input | value: 10}) == success(10)
  end

  test "when number is greater than provided digit length" do
    assert Validate.MaxDigits.validate(%{@input | value: 1000}) == @error
  end
end
