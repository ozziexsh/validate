defmodule ValidateTest.Rules.NotInTest do
  use ExUnit.Case
  doctest Validate.Rules.NotIn

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: [1, 2, 3]
  }

  @error {:error, "must not be one of 1, 2, 3"}

  test "it returns success when value is not in array" do
    assert Validate.Rules.NotIn.validate(%{@input | value: 4}) == success(4)
  end

  test "it returns error when value is in array" do
    assert Validate.Rules.NotIn.validate(%{@input | value: 1}) == @error
  end
end
