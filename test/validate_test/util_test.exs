defmodule ValidateTest.UtilTest do
  use ExUnit.Case
  doctest Validate.Util

  describe "errors_to_map" do
    test "it keys errors by their path" do
      rules = %{
        "email" => [required: true, type: :string],
        "colors" => [required: true, list: [required: true, type: :number]],
        "address" => [
          required: true,
          map: %{
            "city" => [required: true, type: :string]
          }
        ]
      }

      input = %{
        "email" => "",
        "colors" => ["", 1, "2"],
        "address" => %{
          "city" => 123
        }
      }

      assert {:error, errors} = Validate.validate(input, rules)

      error_map = Validate.Util.errors_to_map(errors)

      assert Map.has_key?(error_map, "email")
      assert Map.has_key?(error_map, "colors.0")
      assert is_list(Map.get(error_map, "colors.0"))
      assert Enum.count(Map.get(error_map, "colors.0")) == 2
      assert Map.has_key?(error_map, "colors.2")
      assert Map.has_key?(error_map, "address.city")
    end
  end
end
