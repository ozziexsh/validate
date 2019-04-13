defmodule ValidateTest.Number do
  use ExUnit.Case
  alias Validate.Number
  doctest Validate.Number

  test "can be called via an atom" do
    input = %{}

    rules = %{
      "balance" => [:number]
    }

    assert Validate.validate(input, rules) == {:error, %{"balance" => "not a number"}}
  end
  
  test "returns error when input is not present" do
    input = %{}

    rules = %{
      "balance" => [&Number.number/1]
    }

    assert Validate.validate(input, rules) == {:error, %{"balance" => "not a number"}}
  end

  test "returns error when input is a string" do
    input = %{
      "balance" => "123"
    }

    rules = %{
      "balance" => [&Number.number/1]
    }

    assert Validate.validate(input, rules) == {:error, %{"balance" => "not a number"}}
  end

  test "returns error when input is a list" do
    input = %{
      "balance" => [1, 2, 3]
    }

    rules = %{
      "balance" => [&Number.number/1]
    }

    assert Validate.validate(input, rules) == {:error, %{"balance" => "not a number"}}
  end

  test "returns error when input is a map" do
    input = %{
      "balance" => %{"key" => "value"}
    }

    rules = %{
      "balance" => [&Number.number/1]
    }

    assert Validate.validate(input, rules) == {:error, %{"balance" => "not a number"}}
  end

  test "returns ok when input is 0" do
    input = %{
      "balance" => 0
    }

    rules = %{
      "balance" => [&Number.number/1]
    }

    assert Validate.validate(input, rules) == {:ok, %{"balance" => 0}}
  end

  test "returns ok when input is float" do
    input = %{
      "balance" => 1.23
    }

    rules = %{
      "balance" => [&Number.number/1]
    }

    assert Validate.validate(input, rules) == {:ok, %{"balance" => 1.23}}
  end
end
