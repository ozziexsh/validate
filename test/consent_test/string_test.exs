defmodule ConsentTest.String do
  use ExUnit.Case
  alias Consent.String
  doctest Consent.String

  test "returns error when input is not present" do
    input = %{}

    rules = %{
      "username" => [&String.string/1]
    }

    assert Consent.validate(input, rules) == {:error, %{"username" => "not a string"}}
  end

  test "returns error when input is an int" do
    input = %{
      "username" => 1
    }

    rules = %{
      "username" => [&String.string/1]
    }

    assert Consent.validate(input, rules) == {:error, %{"username" => "not a string"}}
  end

  test "returns error when input is a list" do
    input = %{
      "username" => [1, 2, 3]
    }

    rules = %{
      "username" => [&String.string/1]
    }

    assert Consent.validate(input, rules) == {:error, %{"username" => "not a string"}}
  end

  test "returns error when input is a map" do
    input = %{
      "username" => %{"key" => "val"}
    }

    rules = %{
      "username" => [&String.string/1]
    }

    assert Consent.validate(input, rules) == {:error, %{"username" => "not a string"}}
  end

  test "returns ok when input is empty string" do
    input = %{
      "username" => ""
    }

    rules = %{
      "username" => [&String.string/1]
    }

    assert Consent.validate(input, rules) == {:ok, %{"username" => ""}}
  end

  test "returns ok when input is a string" do
    input = %{
      "username" => "123"
    }

    rules = %{
      "username" => [&String.string/1]
    }

    assert Consent.validate(input, rules) == {:ok, %{"username" => "123"}}
  end
end
