defmodule ValidateTest.Optional do
  use ExUnit.Case
  alias Validate.String
  alias Validate.Optional

  doctest Validate.Optional

  test "it should return skip when not present" do
    input = %{}

    assert Optional.optional(Map.get(input, "username")) == {:skip}
  end

  test "it should return skip when nil" do
    input = %{
      "username" => nil
    }

    assert Optional.optional(Map.get(input, "username")) == {:skip}
  end

  test "it can be called via an atom" do
    input = %{}

    rules = %{
      "username" => [:optional]
    }

    assert Validate.validate(input, rules) == {:ok, %{}}
  end

  test "it should return ok when nil" do
    input = %{}

    rules = %{
      "username" => [&Optional.optional/1]
    }

    assert Validate.validate(input, rules) == {:ok, %{}}
  end

  test "it should return ok when present" do
    input = %{"username" => "123"}

    rules = %{
      "username" => [&Optional.optional/1]
    }

    assert Validate.validate(input, rules) == {:ok, %{"username" => "123"}}
  end

  test "it should not continue to the next validator if not present" do
    input = %{}

    rules = %{
      "username" => [&Optional.optional/1, &String.string/1]
    }

    assert Validate.validate(input, rules) == {:ok, %{}}
  end

  test "it should continue to the next validator if present" do
    input = %{
      "username" => 123
    }

    rules = %{
      "username" => [&Optional.optional/1, &String.string/1]
    }

    assert Validate.validate(input, rules) == {:error, %{"username" => "not a string"}}
  end
end
