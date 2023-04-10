defmodule ValidateTest.Rules.NotStartsWithTest do
  use ExUnit.Case
  doctest Validate.Rules.NotStartsWith

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: "user_"
  }

  @error {:error, "must not start with user_"}

  test "it returns success when string does not start with user_" do
    assert Validate.Rules.NotStartsWith.validate(%{@input | value: "some_user_1234"}) ==
             success("some_user_1234")
  end

  test "it returns error when value does start with user_" do
    assert Validate.Rules.NotStartsWith.validate(%{@input | value: "user_1234"}) == @error
  end
end
