# Consent

Consent, validate incoming requests in an easy to reason-about way using Elixir.

🚨 **Consent is an active WIP. Building mostly for fun/to satisfy my own needs on a project** 🚨

Coming from languages like PHP and Node.js it can be difficult to reason about validating your requests using Ecto. This provides a simple data validation layer that aims to be extensible to allow for custom validation logic provided by the user.

## 🚧 Todo

- Give option to provide atoms in rule lists for simple validators to get rid of needing to import each one
- Test usage with mixed keys (`:atoms` and `"strings"`)
- Add more out-of-the-box validators
- Provide documentation on custom validators
- i18n
- Support more input params than just maps

## 🖥 Installation

The package can be installed
by adding `consent` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:consent, "~> 0.1.0"}
  ]
end
```

## ✅ Usage

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

Validates to false if:

- `undefined`
- `""`
- `[]`
- `{}`

```elixir
alias Consent.Required
data = %{ "username" => "" }
rules = %{
  "username" => [
    &Required.required/1
  ]
}
validate(data, rules)
# {:error, %{ "username" => "required" }}
```
