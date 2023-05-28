defmodule ValidateTest.Rules.RegexTest do
  use ExUnit.Case
  doctest Validate.Rules.Regex

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: ~r/[0-9]/
  }

  @error {:error, "must match pattern [0-9]"}

  test "it can be called from validate" do
    assert Validate.validate("10", regex: ~r/[0-9]/) == success("10")
  end

  test "it returns success when string matches pattern" do
    assert Validate.Rules.Regex.validate(%{@input | value: "1234"}) == success("1234")
  end

  test "it returns error when value does not match pattern" do
    assert Validate.Rules.Regex.validate(%{@input | value: "abcd"}) == @error
  end
end
