defmodule ValidateTest.Rules.SizeTest do
  use ExUnit.Case
  doctest Validate.Rules.Size

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: 3
  }

  @error {:error, "must have a size of exactly 3"}

  test "it can be called from validate" do
    assert Validate.validate("abc", size: 3) == success("abc")
  end

  describe "string" do
    test "returns error when more than 3" do
      assert Validate.Rules.Size.validate(%{@input | value: "1234"}) == @error
    end

    test "returns error when less than 3" do
      assert Validate.Rules.Size.validate(%{@input | value: "12"}) == @error
    end

    test "returns ok when 3" do
      assert Validate.Rules.Size.validate(%{@input | value: "123"}) == success("123")
    end
  end

  describe "list" do
    test "returns error when greater than 3" do
      assert Validate.Rules.Size.validate(%{@input | value: [1, 2, 3, 4]}) == @error
    end

    test "returns error when less than 3" do
      assert Validate.Rules.Size.validate(%{@input | value: [1, 2]}) == @error
    end

    test "returns ok when 3" do
      assert Validate.Rules.Size.validate(%{@input | value: [1, 2, 3]}) == success([1, 2, 3])
    end
  end

  describe "tuple" do
    test "returns error when greater than 3" do
      assert Validate.Rules.Size.validate(%{@input | value: {1, 2, 3, 4}}) == @error
    end

    test "returns error when less than 3" do
      assert Validate.Rules.Size.validate(%{@input | value: {1, 2}}) == @error
    end

    test "returns ok when 3" do
      assert Validate.Rules.Size.validate(%{@input | value: {1, 2, 3}}) == success({1, 2, 3})
    end
  end

  describe "map" do
    test "returns error when greater than 3" do
      assert Validate.Rules.Size.validate(%{@input | value: %{"1": 1, "2": 2, "3": 3, "4": 4}}) ==
               @error
    end

    test "returns error when less than 3" do
      assert Validate.Rules.Size.validate(%{@input | value: %{"1": 1, "2": 2}}) ==
               @error
    end

    test "returns ok when 3" do
      assert Validate.Rules.Size.validate(%{@input | value: %{"1": 1, "2": 2, "3": 3}}) ==
               success(%{"1": 1, "2": 2, "3": 3})
    end
  end
end
