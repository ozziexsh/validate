defmodule ValidateTest.Rules.NullableTest do
  use ExUnit.Case
  doctest Validate.Rules.Nullable

  import Validate.Validator

  @input %{
    value: nil,
    input: "",
    arg: true
  }

  @error {:error, "must not be nil"}

  test "it returns halt when value is nil and nullable: true" do
    assert Validate.Rules.Nullable.validate(%{@input | value: nil}) == halt()
  end

  test "it returns error when value is nil and nullable: false" do
    assert Validate.Rules.Nullable.validate(%{@input | value: nil, arg: false}) == @error
  end

  test "it returns success when value is present and nullable: true" do
    assert Validate.Rules.Nullable.validate(%{@input | value: "abcd", arg: true}) ==
             success("abcd")
  end

  test "it returns success when value is present and nullable: false" do
    assert Validate.Rules.Nullable.validate(%{@input | value: "abcd", arg: false}) ==
             success("abcd")
  end
end
