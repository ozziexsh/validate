defmodule ValidateTest.StartsWithTest do
  use ExUnit.Case
  doctest Validate.StartsWith

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: "user_"
  }

  @error {:error, "must start with user_"}

  test "it returns success when string starts with user_" do
    assert Validate.StartsWith.validate(%{@input | value: "user_1234"}) == success("user_1234")
  end

  test "it returns error when value does not start with user_" do
    assert Validate.StartsWith.validate(%{@input | value: "abcd"}) == @error
  end
end
