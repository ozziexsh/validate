defmodule ValidateTest.Rules.FilledTest do
  use ExUnit.Case
  doctest Validate.Rules.Filled

  import Validate.Validator
  alias Validate.Rules.Filled

  @input_true %{
    value: "",
    input: "",
    arg: true
  }

  @input_false %{
    value: "",
    input: "",
    arg: false
  }

  @error_true {:error, "must be filled"}
  @error_false {:error, "must not be filled"}

  test "it can be called from validate" do
    assert Validate.validate(10, filled: true) == success(10)
  end

  describe "arg: true - strings" do
    test "it returns error when empty" do
      assert Filled.validate(@input_true) == @error_true
    end

    test "it returns ok when present" do
      assert Filled.validate(%{@input_true | value: "here"}) == success("here")
    end
  end

  describe "arg: true - lists" do
    test "it returns error when empty" do
      assert Filled.validate(%{@input_true | value: []}) == @error_true
    end

    test "it returns ok when present" do
      assert Filled.validate(%{@input_true | value: [1]}) == success([1])
    end
  end

  describe "arg: true - maps" do
    test "it returns error when empty" do
      assert Filled.validate(%{@input_true | value: %{}}) == @error_true
    end

    test "it returns ok when present" do
      assert Filled.validate(%{@input_true | value: %{not: "empty"}}) ==
               success(%{not: "empty"})
    end
  end

  describe "arg: true - tuples" do
    test "it returns error when empty" do
      assert Filled.validate(%{@input_true | value: {}}) == @error_true
    end

    test "it returns ok when present" do
      assert Filled.validate(%{@input_true | value: {1, 2}}) == success({1, 2})
    end
  end

  describe "arg: true - nil" do
    test "it returns error when empty" do
      assert Filled.validate(%{@input_true | value: nil}) == @error_true
    end
  end

  describe "arg: false - strings" do
    test "it returns ok when empty" do
      assert Filled.validate(@input_false) == success("")
    end

    test "it returns error when present" do
      assert Filled.validate(%{@input_false | value: "here"}) == @error_false
    end
  end

  describe "arg: false - lists" do
    test "it returns ok when empty" do
      assert Filled.validate(%{@input_false | value: []}) == success([])
    end

    test "it returns error when present" do
      assert Filled.validate(%{@input_false | value: [1]}) == @error_false
    end
  end

  describe "arg: false - maps" do
    test "it returns ok when empty" do
      assert Filled.validate(%{@input_false | value: %{}}) == success(%{})
    end

    test "it returns error when present" do
      assert Filled.validate(%{@input_false | value: %{not: "empty"}}) == @error_false
    end
  end

  describe "arg: false - tuples" do
    test "it returns ok when empty" do
      assert Filled.validate(%{@input_false | value: {}}) == success({})
    end

    test "it returns error when present" do
      assert Filled.validate(%{@input_false | value: {1, 2}}) == @error_false
    end
  end

  describe "arg: false - nil" do
    test "it returns ok when empty" do
      assert Filled.validate(%{@input_false | value: nil}) == success(nil)
    end
  end
end
