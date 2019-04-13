# Validate

Validate incoming requests in an easy to reason-about way using Elixir.

🚨 **Validate is an active WIP. Building mostly for fun/to satisfy my own needs on a project** 🚨

Coming from languages like PHP and Node.js it can be difficult to reason about validating your requests using Ecto. This provides a simple data validation layer that aims to be extensible to allow for custom validation logic provided by the user.

## Todo

- ~~Give option to provide atoms in rule lists for simple validators to get rid of needing to import each one~~
- Test usage with mixed keys (`:atoms` and `"strings"`)
- Add more out-of-the-box validators
- Provide documentation on custom validators
- i18n
- Support more input params than just maps

## Installation

The package can be installed
by adding `validate` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:validate, "~> 0.2.2"}
  ]
end
```

## Usage

```elixir
defmodule MyApp.UserController do
  import Validate

  def create(conn, params) do
    case validate(params, create_rules) do
      {:ok, data} ->
        # ... create user
        # `data` is filtered to only the keys provided in `rules`

      {:error, errors} ->
        # errors is a map that matches the rules provided
        # in this case: %{ "username" => "required" }
        json(conn, errors)
    end
  end

  defp create_rules, do: %{
    "username": [:required],
  }
end
```

## Validators

### Required

Validates input is not:

- `undefined`
- `null`
- `""`
- `[]`
- `{}`

```elixir
import Validate
data = %{ "username" => "" }
rules = %{
  "username" => [
    :required
  ]
}
validate(data, rules)
# {:error, %{ "username" => "required" }}
```

### Optional

Does not continue with the rest of the validators if the value is not present or nil

- `undefined`
- `null`

```elixir
import Validate
data = %{}
rules = %{
  "username" => [
    :optional,
    :string,
  ]
}
# value not present, so it's ok
validate(data, rules)
# {:ok, %{}}
```

```elixir
import Validate
data = %{ "username" => 123 }
rules = %{
  "username" => [
    :optional,
    :string,
  ]
}
# value present, so it continues on to next validators
validate(data, rules)
# {:error, %{"username" => "not a string"}}
```

### String

Validates input is a string

```elixir
import Validate
data = %{
  "username" => 123
}
rules = %{
  "username" => [
    :string,
  ]
}
validate(data, rules)
# {:error, %{"username" => "not a string"}}
```

### Number

Validates input is a number (float or int)

```elixir
import Validate
data = %{
  "balance" => "very low"
}
rules = %{
  "balance" => [
    :number,
  ]
}
validate(data, rules)
# {:error, %{"balance" => "not a number"}}
```

### List

Validates input is a list (array)

```elixir
import Validate
data = %{
  "cities" => "saskatoon"
}
rules = %{
  "cities" => [
    :list,
  ]
}
validate(data, rules)
# {:error, %{"balance" => "not a list"}}
```

### Map

Validates input is a map (object). Can be used to specify nested validations.

Simple use case:

```elixir
import Validate
data = %{
  "user" => 123
}
rules = %{
  "user" => [:map]
}
validate(data, rules)
# {:error, %{"user" => "not a map"}}
```

Nested use case:

```elixir
import Validate
data = %{
  "user" => %{
    "username" => "nehero",
    "password" => "",
    "team" => %{
      "name" => ""
    }
  }
}
rules = %{
  "user" => [
    :required,
    :map: %{
      "username" => [:required, :string],
      "password" => [:required, :string],
      "team" => %{
        "name" => [:required, :string]
      }
    }
  ]
}
validate(data, rules)
#{
#  :error,
#  %{
#    "user" => %{
#      "password" => "required",
#      "team" => %{
#        "name" => "required"
#      }
#    }
#  }
#}
"""
```
