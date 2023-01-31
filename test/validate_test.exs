defmodule ValidateTest do
  use ExUnit.Case
  alias Validate.Required
  doctest Validate

  test "validates a single input" do
    input = %{username: ""}
    rules = %{username: [Required.required()]}
    assert Validate.validate(input, rules) == {:error, %{username: "required"}}
  end

  test "validates multiple inputs" do
    input = %{username: "", password: ""}

    rules = %{
      username: [Required.required()],
      password: [Required.required()]
    }

    assert Validate.validate(input, rules) ==
             {:error, %{username: "required", password: "required"}}
  end

  test "it fails if even one fails" do
    input = %{username: "test", password: "", password_confirmation: "123"}

    rules = %{
      username: [Required.required()],
      password: [Required.required()],
      password_confirmation: [Required.required()]
    }

    assert Validate.validate(input, rules) ==
             {:error, %{password: "required"}}
  end

  test "it returns ok when all rules pass" do
    input = %{username: "test"}

    rules = %{
      username: [Required.required()]
    }

    assert Validate.validate(input, rules) ==
             {:ok, %{username: "test"}}
  end

  test "it filters out data to only keys provided in rules" do
    input = %{username: "test", password: "123", password_confirmation: "123"}

    rules = %{
      username: [Required.required()]
    }

    assert Validate.validate(input, rules) ==
             {:ok, %{username: "test"}}
  end

  test "it supports predefined atoms as validators" do
    input = %{}
    rules = %{username: [:required, :string]}

    assert Validate.validate(input, rules) ==
             {:error, %{username: "required"}}
  end
end
