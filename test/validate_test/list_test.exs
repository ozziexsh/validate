defmodule ValidateTest.List do
  use ExUnit.Case
  alias Validate.List
  doctest Validate.List

  test "can be called via an atom" do
    input = %{}

    rules = %{
      "cities" => [:list]
    }

    assert Validate.validate(input, rules) == {:error, %{"cities" => "not a list"}}
  end

  test "returns error when input is not present" do
    input = %{}

    rules = %{
      "cities" => [&List.list/1]
    }

    assert Validate.validate(input, rules) == {:error, %{"cities" => "not a list"}}
  end

  test "returns error when input is an int" do
    input = %{
      "cities" => 123
    }

    rules = %{
      "cities" => [&List.list/1]
    }

    assert Validate.validate(input, rules) == {:error, %{"cities" => "not a list"}}
  end

  test "returns error when input is a map" do
    input = %{
      "cities" => %{"key" => "value"}
    }

    rules = %{
      "cities" => [&List.list/1]
    }

    assert Validate.validate(input, rules) == {:error, %{"cities" => "not a list"}}
  end

  test "returns error when input is a string" do
    input = %{
      "cities" => "123"
    }

    rules = %{
      "cities" => [&List.list/1]
    }

    assert Validate.validate(input, rules) == {:error, %{"cities" => "not a list"}}
  end

  test "returns ok when input is a string" do
    input = %{
      "cities" => ["saskatoon", "regina"]
    }

    rules = %{
      "cities" => [&List.list/1]
    }

    assert Validate.validate(input, rules) == {:ok, %{"cities" => ["saskatoon", "regina"]}}
  end
end
