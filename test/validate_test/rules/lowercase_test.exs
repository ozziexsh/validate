defmodule ValidateTest.Rules.LowercaseTest do
  use ExUnit.Case
  doctest Validate.Rules.Lowercase

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: true
  }

  @error_true {:error, "must be in lowercase"}
  @error_false {:error, "must not be in lowercase"}

  test "it can be called from validate" do
    assert Validate.validate("ok", lowercase: true) == success("ok")
  end

  describe "lowercase: true" do
    test "when the string is lowercase return success" do
      assert Validate.Rules.Lowercase.validate(%{@input | value: "abcd"}) == success("abcd")
    end

    test "when the string is not lowercase return error" do
      assert Validate.Rules.Lowercase.validate(%{@input | value: "aBcD"}) == @error_true
    end
  end

  describe "lowercase: false" do
    test "when the string is lowercase return error" do
      assert Validate.Rules.Lowercase.validate(%{@input | arg: false, value: "abcd"}) ==
               @error_false
    end

    test "when the string is not lowercase return success" do
      assert Validate.Rules.Lowercase.validate(%{@input | arg: false, value: "aBcD"}) ==
               success("aBcD")
    end
  end
end
