defmodule ValidateTest.Rules.JsonTest do
  use ExUnit.Case
  doctest Validate.Rules.Json

  alias Validate.Rules.Json
  import Validate.Validator

  @input %{
    value: "{\"test\": true}",
    input: "",
    arg: nil
  }

  @error {:error, "not a valid json string"}

  test "it can be called from validate" do
    assert Validate.validate(@input.value, json: true) == success(@input.value)
  end

  test "it succeeds when json string is valid" do
    assert Json.validate(@input) == success(@input.value)
  end

  test "it fails when json string cant be decoded" do
    assert Json.validate(%{@input | value: "asdf"}) == @error
  end
end
