defmodule ValidateTest.InTest do
  use ExUnit.Case
  doctest Validate.In

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: [1, 2, 3]
  }

  @error {:error, "must be one of 1, 2, 3"}

  test "it returns success when value is in array" do
    assert Validate.In.validate(%{@input | value: 1}) == success(1)
  end

  test "it returns error when value is not in array" do
    assert Validate.In.validate(%{@input | value: "abcd"}) == @error
  end
end
