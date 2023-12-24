defmodule ValidateTest.Rules.PresentTest do
  alias Validate.Rules.Present
  use ExUnit.Case
  doctest Validate.Rules.Present

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: true,
    parent: nil,
    name: ""
  }

  @error_true {:halt, "must be present"}
  @error_false {:halt, "must not be present"}

  describe "root validator" do
    test "present: true requires a key to be present in a map" do
      {:error, errors} = Validate.validate(%{}, %{"email" => [present: true, type: :string]})
      error = List.first(errors)

      assert error.path == ["email"]
      assert error.rule == :present

      assert {:ok, _data} =
               Validate.validate(%{"email" => "asdf"}, %{
                 "email" => [present: true, type: :string]
               })
    end

    test "present: false requires a key to be missing in a map" do
      {:error, errors} =
        Validate.validate(%{"email" => ""}, %{"email" => [present: false, type: :string]})

      error = List.first(errors)

      assert error.path == ["email"]
      assert error.rule == :present

      assert {:ok, data} =
               Validate.validate(%{}, %{
                 "email" => [present: false, type: :string]
               })

      assert data == %{}
    end
  end

  describe "arg: true" do
    test "when key is present it returns ok" do
      assert Present.validate(%{
               @input
               | parent: %{"email" => ""},
                 value: "",
                 name: "email"
             }) == success("")
    end

    test "when key is missing it returns error" do
      assert Present.validate(%{
               @input
               | parent: %{},
                 value: "",
                 name: "email"
             }) == @error_true
    end
  end

  describe "arg: false" do
    test "when key is present it returns error" do
      assert Present.validate(%{
               @input
               | parent: %{"email" => ""},
                 value: "",
                 name: "email",
                 arg: false
             }) == @error_false
    end

    test "when key is missing it returns ok" do
      assert Present.validate(%{
               @input
               | parent: %{},
                 value: nil,
                 name: "email",
                 arg: false
             }) == ignore()
    end
  end
end
