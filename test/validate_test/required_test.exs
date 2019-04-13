defmodule ValidateTest.Required do
  use ExUnit.Case
  alias Validate.Required
  doctest Validate.Required

  test "it can be called via an atom" do
    input = %{}

    rules = %{
      "username" => [:required]
    }

    assert Validate.validate(input, rules) == {:error, %{"username" => "required"}}
  end

  test "returns error when input is not present" do
    input = %{}

    rules = %{
      "username" => [&Required.required/1]
    }

    assert Validate.validate(input, rules) == {:error, %{"username" => "required"}}
  end

  test "returns error when string and empty" do
    input = %{"username" => ""}

    rules = %{
      "username" => [&Required.required/1]
    }

    assert Validate.validate(input, rules) ==
             {:error, %{"username" => "required"}}
  end

  test "returns ok when string and not empty" do
    input = %{"username" => "allo"}

    rules = %{
      "username" => [&Required.required/1]
    }

    assert Validate.validate(input, rules) ==
             {:ok, %{"username" => "allo"}}
  end

  test "returns error when list and empty" do
    input = %{"username" => []}

    rules = %{
      "username" => [&Required.required/1]
    }

    assert Validate.validate(input, rules) ==
             {:error, %{"username" => "required"}}
  end

  test "returns ok when list and not empty" do
    input = %{"username" => [1, 2, 3]}

    rules = %{
      "username" => [&Required.required/1]
    }

    assert Validate.validate(input, rules) ==
             {:ok, %{"username" => [1, 2, 3]}}
  end

  test "returns error when map and empty" do
    input = %{"map" => %{}}

    rules = %{
      "map" => [&Required.required/1]
    }

    assert Validate.validate(input, rules) ==
             {:error, %{"map" => "required"}}
  end

  test "it does not continue to next validators on error" do
    input = %{"username" => ""}

    rules = %{
      "username" => [:required, :string]
    }

    assert Validate.validate(input, rules) ==
             {:error, %{"username" => "required"}}
  end

  test "returns ok when map and not empty" do
    input = %{"map" => %{"key" => "value"}}

    rules = %{
      "map" => [&Required.required/1]
    }

    assert Validate.validate(input, rules) ==
             {:ok, %{"map" => %{"key" => "value"}}}
  end

  test "returns ok a number" do
    rules = %{
      "value" => [&Required.required/1]
    }

    assert Validate.validate(%{"value" => 0}, rules) ==
             {:ok, %{"value" => 0}}

    assert Validate.validate(%{"value" => -1}, rules) ==
             {:ok, %{"value" => -1}}

    assert Validate.validate(%{"value" => 1}, rules) ==
             {:ok, %{"value" => 1}}
  end
end
