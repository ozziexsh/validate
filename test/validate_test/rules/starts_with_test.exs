defmodule ValidateTest.Rules.StartsWithTest do
  use ExUnit.Case
  doctest Validate.Rules.StartsWith

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: "user_"
  }

  @error {:error, "must start with user_"}

  test "it can be called from validate" do
    assert Validate.validate("user_123", starts_with: "user_") == success("user_123")
  end

  test "it returns success when string starts with user_" do
    assert Validate.Rules.StartsWith.validate(%{@input | value: "user_1234"}) ==
             success("user_1234")
  end

  test "it returns error when value does not start with user_" do
    assert Validate.Rules.StartsWith.validate(%{@input | value: "abcd"}) == @error
  end
end
