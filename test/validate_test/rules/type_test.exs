defmodule ValidateTest.Rules.TypeTest do
  use ExUnit.Case
  doctest Validate.Rules.Type
  alias Validate.Rules.Type

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: ""
  }

  test "it can be called from validate" do
    assert Validate.validate(10, type: :integer) == success(10)
  end

  test "atom" do
    value = :any
    assert Type.validate(%{@input | value: value, arg: :atom}) == success(value)
  end

  test "binary" do
    value = <<0, 1>>
    assert Type.validate(%{@input | value: value, arg: :binary}) == success(value)
  end

  test "boolean" do
    value = true
    assert Type.validate(%{@input | value: value, arg: :boolean}) == success(value)

    value = false
    assert Type.validate(%{@input | value: value, arg: :boolean}) == success(value)
  end

  test "float" do
    value = 10.10
    assert Type.validate(%{@input | value: value, arg: :float}) == success(value)
  end

  test "function" do
    value = fn -> 10 end
    assert Type.validate(%{@input | value: value, arg: :function}) == success(value)
  end

  test "integer" do
    value = 10
    assert Type.validate(%{@input | value: value, arg: :integer}) == success(value)
  end

  test "list" do
    value = []
    assert Type.validate(%{@input | value: value, arg: :list}) == success(value)
  end

  test "map" do
    value = %{}
    assert Type.validate(%{@input | value: value, arg: :map}) == success(value)
  end

  test "number" do
    value = 10
    assert Type.validate(%{@input | value: value, arg: :number}) == success(value)

    value = 10.10
    assert Type.validate(%{@input | value: value, arg: :number}) == success(value)
  end

  test "string" do
    value = "abcd"
    assert Type.validate(%{@input | value: value, arg: :string}) == success(value)
  end

  test "tuple" do
    value = {1, 2}
    assert Type.validate(%{@input | value: value, arg: :tuple}) == success(value)
  end

  test "date" do
    value = Date.utc_today()
    assert Type.validate(%{@input | value: value, arg: :date}) == success(value)
  end

  test "datetime" do
    value = DateTime.utc_now()
    assert Type.validate(%{@input | value: value, arg: :datetime}) == success(value)
  end

  test "naive_datetime" do
    value = NaiveDateTime.utc_now()
    assert Type.validate(%{@input | value: value, arg: :naive_datetime}) == success(value)
  end

  test "errors" do
    assert Type.validate(%{@input | value: [], arg: :number}) ==
             halt("expected number received list")
  end
end
