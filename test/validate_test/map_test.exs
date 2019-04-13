defmodule ValidateTest.Map do
  use ExUnit.Case
  doctest Validate.Map

  test "can be called via an atom" do
    input = %{}

    rules = %{
      "user" => [:map]
    }

    assert Validate.validate(input, rules) == {:error, %{"user" => "not a map"}}
  end

  test "returns error when input is not present" do
    input = %{}

    rules = %{
      "user" => [:map]
    }

    assert Validate.validate(input, rules) == {:error, %{"user" => "not a map"}}
  end

  test "returns error when input is an int" do
    input = %{
      "user" => 123
    }

    rules = %{
      "user" => [:map]
    }

    assert Validate.validate(input, rules) == {:error, %{"user" => "not a map"}}
  end

  test "returns error when input is a string" do
    input = %{
      "user" => "123"
    }

    rules = %{
      "user" => [:map]
    }

    assert Validate.validate(input, rules) == {:error, %{"user" => "not a map"}}
  end

  test "returns ok when input is a map" do
    input = %{
      "user" => %{
        "username" => "test"
      }
    }

    rules = %{
      "user" => [:map]
    }

    assert Validate.validate(input, rules) ==
             {:ok,
              %{
                "user" => %{
                  "username" => "test"
                }
              }}
  end

  test "it validates that the input is a map before doing nested validation" do
    input = %{
      "user" => 123
    }

    rules = %{
      "user" => [map: %{"username" => [:required]}]
    }

    assert Validate.validate(input, rules) ==
             {:error,
              %{
                "user" => "not a map"
              }}
  end

  test "it validates 1 level deep" do
    input = %{
      "user" => %{
        "username" => ""
      }
    }

    rules = %{
      "user" => [map: %{"username" => [:required]}]
    }

    assert Validate.validate(input, rules) ==
             {:error,
              %{
                "user" => %{
                  "username" => "required"
                }
              }}
  end

  test "it validates multiple nested errors" do
    input = %{
      "user" => %{
        "username" => "test",
        "password" => "",
        "team" => %{
          "name" => ""
        }
      }
    }

    rules = %{
      "user" => [
        map: %{
          "username" => [:required],
          "password" => [:required],
          "team" => [map: %{"name" => [:required]}]
        }
      ]
    }

    assert Validate.validate(input, rules) ==
             {:error,
              %{
                "user" => %{
                  "password" => "required",
                  "team" => %{
                    "name" => "required"
                  }
                }
              }}
  end
end
