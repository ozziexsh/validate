defmodule ValidateTest.Rules.InTest do
  use ExUnit.Case
  doctest Validate.Rules.In

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: [1, 2, 3]
  }

  @error {:error, "must be one of 1, 2, 3"}

  test "it can be called from validate" do
    assert Validate.validate(10, in: [1, 2, 10]) == success(10)
  end

  test "it returns success when value is in array" do
    assert Validate.Rules.In.validate(%{@input | value: 1}) == success(1)
  end

  test "it returns error when value is not in array" do
    assert Validate.Rules.In.validate(%{@input | value: "abcd"}) == @error
  end
end
