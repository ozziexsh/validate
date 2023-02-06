defmodule ValidateTest.List do
  use ExUnit.Case
  alias Validate.List
  doctest Validate.List

  test "can be called via an atom" do
    input = %{}

    rules = %{
      cities: [:list]
    }

    assert Validate.validate(input, rules) == {:error, %{cities: "not a list"}}
  end

  test "returns error when input is not present" do
    input = %{}

    rules = %{
      cities: [List.list()]
    }

    assert Validate.validate(input, rules) == {:error, %{cities: "not a list"}}
  end

  test "returns error when input is an int" do
    input = %{
      cities: 123
    }

    rules = %{
      cities: [List.list()]
    }

    assert Validate.validate(input, rules) == {:error, %{cities: "not a list"}}
  end

  test "returns error when input is a map" do
    input = %{
      cities: %{key: "value"}
    }

    rules = %{
      cities: [List.list()]
    }

    assert Validate.validate(input, rules) == {:error, %{cities: "not a list"}}
  end

  test "returns error when input is a string" do
    input = %{
      cities: "123"
    }

    rules = %{
      cities: [List.list()]
    }

    assert Validate.validate(input, rules) == {:error, %{cities: "not a list"}}
  end

  test "returns ok when input is a list of strings" do
    input = %{
      cities: ["saskatoon", "regina"]
    }

    rules = %{
      cities: [List.list()]
    }

    assert Validate.validate(input, rules) == {:ok, %{cities: ["saskatoon", "regina"]}}
  end

  test "returns errors for flat lists" do
    input = %{
      users: [1, "joe", 3]
    }

    rules = %{
      users: [
        :required,
        list: [:required, :string]
      ]
    }

    assert Validate.validate(input, rules) ==
             {:error,
              %{
                "users.0": "not a string",
                "users.2": "not a string"
              }}
  end

  test "returns errors for nested list maps" do
    input = %{
      users: [
        %{id: 1, name: "joe"},
        %{id: 1, name: 123}
      ]
    }

    rules = %{
      users: [
        :required,
        list: %{
          id: [:required, :number],
          name: [:required, :string]
        }
      ]
    }

    assert Validate.validate(input, rules) ==
             {:error,
              %{
                "users.1.name": "not a string"
              }}
  end

  test "it validates and preserves key types" do
    input = %{
      "users" => [
        %{
          "username" => "test",
          "team" => %{
            "name" => "test"
          }
        },
        %{
          "username" => "test2",
          "team" => %{
            "name" => "test2"
          }
        }
      ]
    }

    rules = %{
      "users" => [
        list: %{
          "username" => [:required],
          "team" => [map: %{"name" => [:required]}]
        }
      ]
    }

    assert Validate.validate(input, rules) ==
             {:ok,
              %{
                "users" => [
                  %{
                    "username" => "test",
                    "team" => %{"name" => "test"}
                  },
                  %{
                    "username" => "test2",
                    "team" => %{"name" => "test2"}
                  }
                ]
              }}
  end
end
