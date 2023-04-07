defmodule ValidateTest.HaltTest do
  use ExUnit.Case

  test "it does not validate any further rules when halt returned" do
    rules = %{
      "email" => [
        required: true,
        type: :string,
        min: 5
      ]
    }

    input = %{
      "email" => ""
    }

    assert {:error, errors} = Validate.validate(input, rules)
    assert Enum.count(errors) == 1
  end

  test "it does not validate any further nested rules when halt returned" do
    rules = %{
      "address" => [
        required: true,
        map: %{
          "line1" => [required: true, type: :number]
        }
      ]
    }

    input = %{
      "address" => nil
    }

    assert {:error, errors} = Validate.validate(input, rules)
    assert Enum.count(errors) == 1
    assert [%{path: ["address"]}] = errors

    input = %{
      "address" => %{
        "line1" => ""
      }
    }

    assert {:error, errors} = Validate.validate(input, rules)
    assert Enum.count(errors) == 1
    assert [%{path: ["address", "line1"]}] = errors
  end
end
