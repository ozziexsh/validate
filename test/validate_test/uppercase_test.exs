defmodule ValidateTest.UppercaseTest do
  use ExUnit.Case
  doctest Validate.Uppercase

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: true
  }

  @error_true {:error, "must be in uppercase"}
  @error_false {:error, "must not be in uppercase"}

  describe "uppercase: true" do
    test "when the string is uppercase return success" do
      assert Validate.Uppercase.validate(%{@input | value: "ABCD"}) == success("ABCD")
    end

    test "when the string is not uppercase return error" do
      assert Validate.Uppercase.validate(%{@input | value: "aBcD"}) == @error_true
    end
  end

  describe "uppercase: false" do
    test "when the string is uppercase return error" do
      assert Validate.Uppercase.validate(%{@input | arg: false, value: "ABCD"}) == @error_false
    end

    test "when the string is not uppercase return success" do
      assert Validate.Uppercase.validate(%{@input | arg: false, value: "aBcD"}) == success("aBcD")
    end
  end
end
