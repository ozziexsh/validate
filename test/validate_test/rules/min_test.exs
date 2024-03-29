defmodule ValidateTest.Rules.MinTest do
  use ExUnit.Case
  doctest Validate.Rules.Min

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: 3
  }

  @error {:error, "must be at least 3"}

  test "it can be called from validate" do
    assert Validate.validate(10, min: 5) == success(10)
  end

  describe "string" do
    test "returns error when less than 3" do
      assert Validate.Rules.Min.validate(@input) == @error
      assert Validate.Rules.Min.validate(%{@input | value: "12"}) == @error
    end

    test "returns ok when 3 or greater" do
      [one, two] = ["123", "1234"]
      assert Validate.Rules.Min.validate(%{@input | value: one}) == success(one)
      assert Validate.Rules.Min.validate(%{@input | value: two}) == success(two)
    end
  end

  describe "number" do
    test "returns error when less than 3" do
      assert Validate.Rules.Min.validate(%{@input | value: 0}) == @error
      assert Validate.Rules.Min.validate(%{@input | value: 2}) == @error
    end

    test "returns ok when 3 or greater" do
      [one, two] = [3, 4]
      assert Validate.Rules.Min.validate(%{@input | value: one}) == success(one)
      assert Validate.Rules.Min.validate(%{@input | value: two}) == success(two)
    end
  end

  describe "list" do
    test "returns error when less than 3" do
      assert Validate.Rules.Min.validate(%{@input | value: []}) == @error
      assert Validate.Rules.Min.validate(%{@input | value: [1, 2]}) == @error
    end

    test "returns ok when 3 or greater" do
      [one, two] = [[1, 2, 3], [1, 2, 3, 4]]
      assert Validate.Rules.Min.validate(%{@input | value: one}) == success(one)
      assert Validate.Rules.Min.validate(%{@input | value: two}) == success(two)
    end
  end

  describe "tuple" do
    test "returns error when less than 3" do
      assert Validate.Rules.Min.validate(%{@input | value: {}}) == @error
      assert Validate.Rules.Min.validate(%{@input | value: {1, 2}}) == @error
    end

    test "returns ok when 3 or greater" do
      [one, two] = [{1, 2, 3}, {1, 2, 3, 4}]
      assert Validate.Rules.Min.validate(%{@input | value: one}) == success(one)
      assert Validate.Rules.Min.validate(%{@input | value: two}) == success(two)
    end
  end

  describe "map" do
    test "returns error when less than 3" do
      assert Validate.Rules.Min.validate(%{@input | value: %{}}) == @error
      assert Validate.Rules.Min.validate(%{@input | value: %{"1": 1, "2": 2}}) == @error
    end

    test "returns ok when 3 or greater" do
      [one, two] = [%{"1": 1, "2": 2, "3": 3}, %{"1": 1, "2": 2, "3": 3, "4": 4}]
      assert Validate.Rules.Min.validate(%{@input | value: one}) == success(one)
      assert Validate.Rules.Min.validate(%{@input | value: two}) == success(two)
    end
  end
end
