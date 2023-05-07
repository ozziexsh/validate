defmodule ValidateTest.Rules.CastTest do
  use ExUnit.Case
  doctest Validate.Rules.Cast
  alias Validate.Rules.Cast

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: :string
  }

  describe "arg: :atom" do
    test "it returns an atom if given an atom" do
      assert Cast.validate(%{@input | arg: :atom, value: :ok}) == success(:ok)
    end

    test "it converts a string to atom" do
      assert Cast.validate(%{@input | arg: :atom, value: "ok"}) == success(:ok)
    end

    test "it converts a float to atom" do
      assert Cast.validate(%{@input | arg: :atom, value: 123.123}) == success(:"123.123")
    end

    test "it converts an integer to atom" do
      assert Cast.validate(%{@input | arg: :atom, value: 123}) == success(:"123")
    end

    test "it converts nil to empty atom" do
      assert Cast.validate(%{@input | arg: :atom, value: nil}) == success(:"")
    end
  end

  describe "arg: :boolean" do
    test "it returns a boolean if given a boolean" do
      assert Cast.validate(%{@input | arg: :boolean, value: true}) == success(true)
      assert Cast.validate(%{@input | arg: :boolean, value: false}) == success(false)
    end

    test "it returns a boolean if given a string" do
      assert Cast.validate(%{@input | arg: :boolean, value: "123"}) == success(true)
      assert Cast.validate(%{@input | arg: :boolean, value: ""}) == success(true)
    end

    test "it returns a boolean if given an int" do
      assert Cast.validate(%{@input | arg: :boolean, value: 123}) == success(true)
      assert Cast.validate(%{@input | arg: :boolean, value: 0}) == success(true)
    end

    test "it returns a boolean if given a float" do
      assert Cast.validate(%{@input | arg: :boolean, value: 123.123}) == success(true)
      assert Cast.validate(%{@input | arg: :boolean, value: 0.0}) == success(true)
    end

    test "it converts nil to false" do
      assert Cast.validate(%{@input | arg: :boolean, value: nil}) == success(false)
    end
  end

  describe "arg: :float" do
    test "it returns a float if given a float" do
      assert Cast.validate(%{@input | arg: :float, value: 123.123}) == success(123.123)
    end

    test "it converts a string to float" do
      assert Cast.validate(%{@input | arg: :float, value: "123"}) == success(123.0)
    end

    test "it converts an integer to float" do
      assert Cast.validate(%{@input | arg: :float, value: 123}) == success(123.0)
    end

    test "it converts nil to 0" do
      assert Cast.validate(%{@input | arg: :float, value: nil}) == success(0.0)
    end
  end

  describe "arg: :integer" do
    test "it returns an integer if given an integer" do
      assert Cast.validate(%{@input | arg: :integer, value: 123}) == success(123)
    end

    test "it converts a string to integer" do
      assert Cast.validate(%{@input | arg: :integer, value: "123"}) == success(123)
    end

    test "it converts a float to integer" do
      assert Cast.validate(%{@input | arg: :integer, value: 123.123}) == success(123)
    end

    test "it converts nil to 0" do
      assert Cast.validate(%{@input | arg: :integer, value: nil}) == success(0)
    end
  end

  describe "arg: :string" do
    test "it returns a string if given a string" do
      assert Cast.validate(%{@input | value: "123"}) == success("123")
    end

    test "it converts integers to string" do
      assert Cast.validate(%{@input | value: 123}) == success("123")
    end

    test "it converts floats to string" do
      assert Cast.validate(%{@input | value: 123.123}) == success("123.123")
    end

    test "it converts atoms to string" do
      assert Cast.validate(%{@input | value: :ok}) == success("ok")
    end

    test "it converts booleans to string" do
      assert Cast.validate(%{@input | value: true}) == success("true")
    end

    test "it converts nil to empty string" do
      assert Cast.validate(%{@input | value: nil}) == success("")
    end
  end

  describe "arg: [to: type, nil: :preserve]" do
    test "it preserves nil when passed" do
      assert Cast.validate(%{@input | arg: [to: :string, nil: :preserve], value: nil}) ==
               success(nil)
    end

    test "it still converts when not nil" do
      assert Cast.validate(%{@input | arg: [to: :string, nil: :preserve], value: 123}) ==
               success("123")
    end
  end
end
