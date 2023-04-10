defmodule ValidateTest.Rules.RequiredTest do
  use ExUnit.Case
  doctest Validate.Rules.Required

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: true
  }

  @error {:halt, "is required"}

  describe "strings" do
    test "it returns error when empty" do
      assert Validate.Rules.Required.validate(@input) == @error
    end

    test "it returns ok when string present" do
      assert Validate.Rules.Required.validate(%{@input | value: "here"}) == success("here")
    end
  end

  describe "lists" do
    test "it returns error when empty" do
      assert Validate.Rules.Required.validate(%{@input | value: []}) == @error
    end

    test "it returns ok when present" do
      assert Validate.Rules.Required.validate(%{@input | value: [1]}) == success([1])
    end
  end

  describe "maps" do
    test "it returns error when empty" do
      assert Validate.Rules.Required.validate(%{@input | value: %{}}) == @error
    end

    test "it returns ok when present" do
      assert Validate.Rules.Required.validate(%{@input | value: %{not: "empty"}}) ==
               success(%{not: "empty"})
    end
  end

  describe "tuples" do
    test "it returns error when empty" do
      assert Validate.Rules.Required.validate(%{@input | value: {}}) == @error
    end

    test "it returns ok when present" do
      assert Validate.Rules.Required.validate(%{@input | value: {1, 2}}) == success({1, 2})
    end
  end

  describe "nil" do
    test "it returns error when empty" do
      assert Validate.Rules.Required.validate(%{@input | value: nil}) == @error
    end
  end

  describe "arg is false" do
    test "it allows anything" do
      assert Validate.Rules.Required.validate(%{@input | arg: false, value: nil}) == success(nil)
    end
  end
end
