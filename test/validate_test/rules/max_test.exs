defmodule ValidateTest.Rules.MaxTest do
  use ExUnit.Case
  doctest Validate.Rules.Max

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: 3
  }

  @error {:error, "must be at most 3"}

  describe "string" do
    test "returns error when more than 3" do
      assert Validate.Rules.Max.validate(%{@input | value: "1234"}) == @error
    end

    test "returns ok when 3 or less" do
      [one, two] = ["123", ""]
      assert Validate.Rules.Max.validate(%{@input | value: one}) == success(one)
      assert Validate.Rules.Max.validate(%{@input | value: two}) == success(two)
    end
  end

  describe "number" do
    test "returns error when greater than 3" do
      assert Validate.Rules.Max.validate(%{@input | value: 4}) == @error
    end

    test "returns ok when 3 or less" do
      [one, two] = [3, 2]
      assert Validate.Rules.Max.validate(%{@input | value: one}) == success(one)
      assert Validate.Rules.Max.validate(%{@input | value: two}) == success(two)
    end
  end

  describe "list" do
    test "returns error when greater than 3" do
      assert Validate.Rules.Max.validate(%{@input | value: [1, 2, 3, 4]}) == @error
    end

    test "returns ok when 3 or less" do
      [one, two] = [[1, 2, 3], []]
      assert Validate.Rules.Max.validate(%{@input | value: one}) == success(one)
      assert Validate.Rules.Max.validate(%{@input | value: two}) == success(two)
    end
  end

  describe "tuple" do
    test "returns error when greater than 3" do
      assert Validate.Rules.Max.validate(%{@input | value: {1, 2, 3, 4}}) == @error
    end

    test "returns ok when 3 or less" do
      [one, two] = [{1, 2, 3}, {}]
      assert Validate.Rules.Max.validate(%{@input | value: one}) == success(one)
      assert Validate.Rules.Max.validate(%{@input | value: two}) == success(two)
    end
  end

  describe "map" do
    test "returns error when greater than 3" do
      assert Validate.Rules.Max.validate(%{@input | value: %{"1": 1, "2": 2, "3": 3, "4": 4}}) ==
               @error
    end

    test "returns ok when 3 or less" do
      [one, two] = [%{"1": 1, "2": 2, "3": 3}, %{}]
      assert Validate.Rules.Max.validate(%{@input | value: one}) == success(one)
      assert Validate.Rules.Max.validate(%{@input | value: two}) == success(two)
    end
  end
end
