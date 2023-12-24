defmodule ValidateTest do
  use ExUnit.Case
  doctest Validate

  import Validate.Validator

  test "it returns proper errors" do
    rules = %{
      "email" => [
        required: true,
        type: :string
      ],
      "colors" => [
        required: true,
        type: :list,
        list: [
          required: true,
          type: :string
        ]
      ],
      "friends" => [
        required: true,
        type: :list,
        list: [
          required: true,
          map: %{
            "name" => [
              required: true,
              type: :string
            ]
          }
        ]
      ],
      "address" => [
        required: true,
        type: :map,
        map: %{
          "line1" => [
            required: true,
            type: :string
          ],
          "country" => [
            required: true,
            type: :string
          ]
        }
      ]
    }

    input = %{
      "email" => "",
      "colors" => ["blue", "orange", 2],
      "friends" => [
        %{"name" => "oz"},
        %{"name" => ""}
      ],
      "address" => %{
        "line1" => "123 fake st",
        "country" => ""
      },
      "unused" => "this should not be in the final data"
    }

    assert {:error, errors} = Validate.validate(input, rules)
    emailError = Enum.find(errors, fn x -> x.path == ["email"] end)
    colorError = Enum.find(errors, fn x -> x.path == ["colors", 2] end)
    addressError = Enum.find(errors, fn x -> x.path == ["address", "country"] end)
    friendError = Enum.find(errors, fn x -> x.path == ["friends", 1, "name"] end)
    assert %{path: ["email"], rule: :required} = emailError
    assert %{path: ["colors", 2], rule: :type} = colorError
    assert %{path: ["address", "country"], rule: :required} = addressError
    assert %{path: ["friends", 1, "name"], rule: :required} = friendError
  end

  test "it handles single validations" do
    assert {:error, errors} = Validate.validate("", required: true)
    assert [%{path: [], rule: :required}] = errors
  end

  test "it returns only validated data" do
    rules = %{
      "email" => [required: true, type: :string],
      "address" => [
        required: true,
        map: %{
          "line1" => [required: true]
        }
      ]
    }

    input = %{
      "email" => "somethin",
      "address" => %{
        "line1" => "123 fake st",
        "city" => "saskatoon"
      },
      "unexpected" => "asdhadas"
    }

    assert {:ok, data} = Validate.validate(input, rules)
    assert Map.get(data, "unexpected") == nil
    assert Map.get(data, "email") == "somethin"
    assert get_in(data, ["address", "line1"]) == "123 fake st"
    assert get_in(data, ["address", "city"]) == nil
  end

  test "it optionally keeps extraneous data" do
    rules = %{
      "email" => [required: true, type: :string],
      "address" => [
        required: true,
        map: %{
          "line1" => [required: true]
        }
      ]
    }

    input = %{
      "email" => "somethin",
      "address" => %{
        "line1" => "123 fake st",
        "city" => "saskatoon"
      },
      "unexpected" => "asdhadas"
    }

    assert {:ok, data} = Validate.validate(input, rules, filter_keys: false)
    assert Map.get(data, "unexpected") == "asdhadas"
    assert Map.get(data, "email") == "somethin"
    assert get_in(data, ["address", "line1"]) == "123 fake st"
    assert get_in(data, ["address", "city"]) == "saskatoon"
  end

  test "it handles custom validators" do
    rules = %{
      "email" => [
        required: true,
        custom: &if(&1.value == "rabbit", do: success("rabbit"), else: error("custom failed"))
      ]
    }

    assert {:ok, %{"email" => "rabbit"}} == Validate.validate(%{"email" => "rabbit"}, rules)

    assert {:error, [%{path: ["email"], rule: :custom}]} =
             Validate.validate(%{"email" => "season"}, rules)
  end
end
