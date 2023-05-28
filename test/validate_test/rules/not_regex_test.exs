defmodule ValidateTest.Rules.NotRegexTest do
  use ExUnit.Case
  doctest Validate.Rules.NotRegex

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: ~r/[0-9]/
  }

  @error {:error, "must not match pattern [0-9]"}

  test "it can be called from validate" do
    assert Validate.validate("abcd", not_regex: ~r/[0-9]/) == success("abcd")
  end

  test "it returns success when string does not match pattern" do
    assert Validate.Rules.NotRegex.validate(%{@input | value: "abcd"}) == success("abcd")
  end

  test "it returns error when value does match pattern" do
    assert Validate.Rules.NotRegex.validate(%{@input | value: "1234"}) == @error
  end
end
