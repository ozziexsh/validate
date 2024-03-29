defmodule ValidateTest.Rules.NotEndsWithTest do
  use ExUnit.Case
  doctest Validate.Rules.NotEndsWith

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: "_user"
  }

  @error {:error, "must not end with _user"}

  test "it can be called from validate" do
    assert Validate.validate("123_user", not_ends_with: "_team") == success("123_user")
  end

  test "it returns success when string does not end with _user" do
    assert Validate.Rules.NotEndsWith.validate(%{@input | value: "some_user_1234"}) ==
             success("some_user_1234")
  end

  test "it returns error when value does end with _user" do
    assert Validate.Rules.NotEndsWith.validate(%{@input | value: "_user"}) == @error
  end
end
