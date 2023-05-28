defmodule ValidateTest.Rules.EndsWithTest do
  use ExUnit.Case
  doctest Validate.Rules.EndsWith

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: "_user"
  }

  @error {:error, "must end with _user"}

  test "it can be called from validate" do
    assert Validate.validate("user_123", ends_with: "123") == success("user_123")
  end

  test "it returns success when string ends with _user" do
    assert Validate.Rules.EndsWith.validate(%{@input | value: "some_user"}) ==
             success("some_user")
  end

  test "it returns error when value does not end with _user" do
    assert Validate.Rules.EndsWith.validate(%{@input | value: "abcd"}) == @error
  end
end
