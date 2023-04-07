defmodule ValidateTest.EndsWithTest do
  use ExUnit.Case
  doctest Validate.EndsWith

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: "_user"
  }

  @error {:error, "must end with _user"}

  test "it returns success when string ends with _user" do
    assert Validate.EndsWith.validate(%{@input | value: "some_user"}) == success("some_user")
  end

  test "it returns error when value does not end with _user" do
    assert Validate.EndsWith.validate(%{@input | value: "abcd"}) == @error
  end
end
