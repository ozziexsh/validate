defmodule ValidateTest.Rules.UppercaseTest do
  use ExUnit.Case
  doctest Validate.Rules.Uppercase

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: true
  }

  @error_true {:error, "must be in uppercase"}
  @error_false {:error, "must not be in uppercase"}

  test "it can be called from validate" do
    assert Validate.validate("OK", uppercase: true) == success("OK")
  end

  describe "uppercase: true" do
    test "when the string is uppercase return success" do
      assert Validate.Rules.Uppercase.validate(%{@input | value: "ABCD"}) == success("ABCD")
    end

    test "when the string is not uppercase return error" do
      assert Validate.Rules.Uppercase.validate(%{@input | value: "aBcD"}) == @error_true
    end
  end

  describe "uppercase: false" do
    test "when the string is uppercase return error" do
      assert Validate.Rules.Uppercase.validate(%{@input | arg: false, value: "ABCD"}) ==
               @error_false
    end

    test "when the string is not uppercase return success" do
      assert Validate.Rules.Uppercase.validate(%{@input | arg: false, value: "aBcD"}) ==
               success("aBcD")
    end
  end
end
