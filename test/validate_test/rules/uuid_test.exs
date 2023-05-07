defmodule ValidateTest.Rules.UuidTest do
  use ExUnit.Case
  doctest Validate.Rules.Uuid

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: true
  }

  test "valid v4 uuid" do
    value = "123e4567-e89b-12d3-a456-426655440000"
    assert Validate.Rules.Uuid.validate(%{@input | value: value}) == success(value)
  end

  test "invalid v4 uuid" do
    value = "c73bcdcc-2669-4bf6-81d3-e4an73fb11fd"
    assert Validate.Rules.Uuid.validate(%{@input | value: value}) == {:error, "not a valid uuid"}
  end

  test "valid v1 uuid" do
    value = "2a898e60-ebc8-11ed-a05b-0242ac120003"
    assert Validate.Rules.Uuid.validate(%{@input | value: value}) == success(value)
  end
end
