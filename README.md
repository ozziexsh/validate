# Consent

Consent, validate incoming requests in an easy to reason-about way using Elixir.

🚨 **Consent is an active WIP. Building mostly for fun/to satisfy my own needs on a project** 🚨

Coming from languages like PHP and Node.js it can be difficult to reason about validating your requests using Ecto. This provides a simple data validation layer that aims to be extensible to allow for custom validation logic provided by the user.

## Todo

- Give option to provide atoms in rule lists for simple validators to get rid of needing to import each one
- Test usage with mixed keys (`:atoms` and `"strings"`)
- Add more out-of-the-box validators
- Provide documentation on custom validators
- i18n
- Support more input params than just maps

## Installation

The package can be installed
by adding `consent` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:consent, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
defmodule MyApp.UserController do
  import Consent
  import Consent.Required

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
    "username": [&required/1],
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
import Consent
import Consent.Required
data = %{ "username" => "" }
rules = %{
  "username" => [
    &required/1
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
import Consent
import Consent.Optional
import Consent.String
data = %{}
rules = %{
  "username" => [
    &optional/1,
    &string/1,
  ]
}
# value not present, so it's ok
validate(data, rules)
# {:ok, %{}}
```

```elixir
import Consent
import Consent.Optional
import Consent.String
data = %{ "username" => 123 }
rules = %{
  "username" => [
    &optional/1,
    &string/1,
  ]
}
# value present, so it continues on to next validators
validate(data, rules)
# {:error, %{"username" => "not a string"}}
```

### String

Validates input is a string

```elixir
import Consent
import Consent.String
data = %{
  "username" => 123
}
rules = %{
  "username" => [
    &string/1,
  ]
}
validate(data, rules)
# {:error, %{"username" => "not a string"}}
```

### Number

Validates input is a number (float or int)

```elixir
import Consent
import Consent.Number
data = %{
  "balance" => "very low"
}
rules = %{
  "balance" => [
    &number/1,
  ]
}
validate(data, rules)
# {:error, %{"balance" => "not a number"}}
```

### List

Validates input is a list (array)

```elixir
import Consent
import Consent.List
data = %{
  "cities" => "saskatoon"
}
rules = %{
  "cities" => [
    &list/1,
  ]
}
validate(data, rules)
# {:error, %{"balance" => "not a list"}}
```
