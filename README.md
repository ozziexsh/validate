# Validate

Validate data in elixir. Focused on validating incoming http request data but works with all elixir data types.

Coming from languages like PHP and Node.js it can be difficult to reason about validating your requests using Ecto. This provides a simple data validation layer that aims to be extensible to allow for custom validation logic provided by the user.

Inspired by Laravel's validator.

## Installation

Add Validate to your mix.exs dependencies:

```elixir
defp deps do
  [
    {:validate, "~> 1.2"}
  ]
end
```

## Features

- [x] Simple (raw string, bool, etc), nested maps, and list validation
- [x] Built in validation rules
- [x] Custom validation rules
- [x] Return validated keys only
- [x] Plug support
- [ ] i18n

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
  - [Simple Validation](#simple-validation)
  - [Map Validation](#map-validation)
  - [Nested Rules](#nested-rules)
- [Errors](#errors)
  - [Formatting Errors](#formatting-errors)
- [Custom Validation Rules](#custom-validation-rules)
- [Plug](#plug)
- [Built in Validation Rules](#built-in-validation-rules)

## Usage

The basic usage looks like:

```elixir
# data is the validated input
{:ok, data} = Validate.validate(input, rules)

# errors is an array of %Validate.Validator.Error{}
{:error, errors} = Validate.validate(input, rules)
```

### Simple Validation

If you are validating a simple/flat data type (like string, boolean, number), you can simply pass the rules as a keyword list:

```elixir
{:ok, data} = Validate.validate("jane", required: true, type: :string)
```

### Map Validation

If you are validating a map, such as the body of an incoming `post` request, you must pass a map of rules where the keys match the keys that you are validating. Note: the rule keys **must be the same type** as the data keys. If your data keys are strings, use string keys for the rules. If your data keys are atoms, use atoms for the rules. You can mix and match key types in the same map, as long as the keys in the rules mirror the keys in the data.

```elixir
input = %{
  "email" => "test@example.com",
  "age" => 32
}

rules = %{
  "email" => [required: true, type: :string],
  "age" => [required: true, type: :number]
}

{:ok, data} = Validate.validate(input, rules)
```

Important: The data returned from nested validations will always only be the keys specified in the rules. Any keys not specified in the rules are thrown away:

```elixir
input = %{
  "url" => "https://google.com",
  "friends" => [
    %{ "name" => "Jane", "email" => "jane@example.com" },
  ],
  "age" => 28
}

rules = %{
  "url" => [required: true, type: :string],
  "friends" => [
    map: %{
      "name" => [required: true, type: :string]
    }
  ]
}

{:ok, data} = Validate.validate(input, rules)

data == %{
  "url" => "https://google.com",
  "friends" => [
    %{ "name" => "Jane"}
  ]
}
```

### Nested Rules

You can also perform complex validation such as nested lists and maps:

```elixir
input = %{
  "name" => "Jane Doe",
  "colors" => ["red", "green"],
  "address" => %{
    "line1" => "123 Fake St",
    "city" => "Saskatoon"
  },
  "friends" => [
    %{"name" => "John", "email" => "john@example.com"},
    %{"name" => "Michelle", "email" => "michelle@example.com"}
  ]
}

rules = %{
  "name" => [required: true, type: :string],
  "colors" => [
    required: true,
    type: :list,
    list: [required: true, type: :string, in: ~w[blue orange red green purple]]
  ],
  "address" => [
    required: true,
    type: :map,
    map: %{
      "line1" => [required: true, type: :string],
      "city" => [required: true, type: :string],
    }
  ],
  "friends" => [
    required: true,
    type: :list,
    list: [
      required: true,
      type: :map,
      map: %{
        "name" => [required: true, type: :string],
        "email" => [required: true, type: :string]
      }
    ]
  ]
}

{:ok, data} = Validate.validate(input, rules)
```

## Errors

The error array returned contains `%Validate.Validator.Error{}` structs.

When performing simple validations, `path` will be an empty array. When validating maps, `path` will be an array of keys representing the depth to get to the data value. For lists, the numeric index is used for the specific position of the error in the list.

```elixir
[
  %Validate.Validator.Error{
    path: ["name"],
    message: "is required",
    rule: :required
  },
  %Validate.Validator.Error{
    path: ["colors", 2],
    message: "must be a string",
    rule: :type
  },
  %Validate.Validator.Error{
    path: ["address", "line1"],
    message: "is required",
    rule: :required
  },
]
```

### Formatting Errors

Sometimes it is easier to show errors to the user by name instead of looping through the array, so a helper is provided to make this easy:

```elixir
# assuming the error array from the above example
formatted = Validate.Util.errors_to_map(errors)

formatted == %{
  "name" => ["is required"],
  "colors.2" => ["must be a string"],
  "address.line1" => ["is required"]
}
```

## Custom Validation Rules

You can write your own validators by using the `custom:` rule. You can write these as modules or as inline functions.

Validation rules must return one of four possible outcomes:

- `Validate.Validator.success(value)` - Return this when validation passes. You must pass the value back as the first arg. This gives you the opportunity to transform the value if you wish.
- `Validate.Validator.error(message)` - Return this when validation fails. You must pass a message back to the user to let them know why it failed.
- `Validate.Validator.halt(message)` - Return this when validation fails AND you want to prevent any further validation from running on this specific input.
- `Validate.Validator.halt()` - Return this when validation succeeds BUT you do not want any further validations to happen on this specific input.

For example, we could write a custom rule to see if an email already exists in our database:

```elixir
input = %{
  "email" => "hello@example.com"
}

rules = %{
  "email" => [
    required: true,
    type: :string,
    custom: fn %{ value: value } ->
      if MyApp.Accounts.email_exists?(value) do
        Validate.Validator.error("email is already taken")
      else
        Validate.Validator.success(value)
      end
    end
  ]
}
```

If you'd like to have the rule be reusable, you could move it into a module. For further readability, you could also make it a higher-order function to prevent passing function references like `&MyApp.MyRule.validate/1`:

```elixir
defmodule MyApp.EmailExists do
  def validate() do
    fn %{ value: value } ->
      if MyApp.Accounts.email_exists?(value) do
        Validate.Validator.error("email is already taken")
      else
        Validate.Validator.success(value)
      end
    end
  end
end


input = %{
  "email" => "hello@example.com"
}

rules = %{
  "email" => [
    required: true,
    type: :string,
    custom: MyApp.EmailExists.validate(),
  ]
}
```

## Plug

You can use Validate as a plug to simplify your controllers by performing validation and authorization outside of your controller action.

First you need to create a file in your project for the plug. This is required so that you can control what happens when different events occur. Some applications may wish to return JSON, while others want to redirect to a route. Providing this as a macro in your own application gives you the flexibility to handle this how you please.

For this example, we'll create a file called `my_app_web/plugs/form_request.ex`

```elixir
defmodule MyAppWeb.Plugs.FormRequest do
  use Validate.Plugs.FormRequest,
    validate_success: :validate_success,
    validate_error: :validate_error,
    auth_error: :auth_error

  import Plug.Conn

  # called when validation passess
  # use this to make the validated data available to your controller
  def validate_success(conn, data) do
    conn |> assign(:validated, data)
  end

  def validate_error(conn, errors) do
    error_map = Validate.Util.errors_to_map(errors)
    conn |> put_status(422) |> Phoenix.Controller.json(%{errors: error_map}) |> halt()
  end

  def auth_error(conn) do
    conn |> put_status(401) |> Phoenix.Controller.json(%{message: "unauthorized"}) |> halt()
  end
end
```

Now we can create a module that will handle the request. This module can exist anywhere but needs to implement at least a `rules/1` function and optionally an `authorize/1` function. `authorize/1` will be called first if it is present, and only if it returns a truthy value will it continue to validate the input, if it returns a falsy value we will call the `auth_error` function in our plug from earlier. `rules/1` should return a map of rules that will be validated against `conn.params`.

Let's pretend we're making a form to create a team in our application. We might put this in `my_app_web/requests/store_team_request.ex`.

```elixir
defmodule MyAppWeb.Requests.StoreTeamRequest do
  # can only create a team if we do not already have a team
  def authorize(conn) do
    conn.assigns.user && !conn.assigns.team
  end

  def rules(_conn) do
    %{
      "name" => [required: true, type: :string, max: 80],
      "plan" => [required: true, type: :string, in: ["free", "pro"]],
      # ...
    }
  end
end
```

Now we're ready to use this in our controller. Let's assume we have a controller like `my_app_web/controllers/team_controller.ex`.

```elixir
defmodule MyAppWeb.Controllers.TeamController do
  use MyAppWeb, :controller

  plug MyAppWeb.Plugs.FormRequest, MyAppWeb.Requests.StoreTeamRequest when action in [:store]

  def store(conn, params) do
    # now we can operate in here knowing that
    # our request is authorized and the validated data
    # is in conn.assigns.validated
  end
end
```

The controller can be registered like normal in your routes file, and the plug will take care of authorizing and validating before calling the controller action!

```elixir
# inside your routes file somewhere
scope "/" do
  pipe_through [:browser]

  post "/teams", MyAppWeb.Controllers.TeamController, :store
end
```

If you wanted, you could bypass the controller all together by adding a `perform/2` function to the request module and just handle the request right there:

```elixir
defmodule MyAppWeb.Requests.StoreTeamRequest do
  def rules(_conn) do
    %{
      "name" => [required: true, type: :string, max: 80],
      # ...
    }
  end

  def perform(conn, data) do
    # skip the controller and just handle the request here
    # `data` is the validated data
  end
end

# then in your router file
scope "/" do
  pipe_through [:browser]

  post "/teams", MyAppWeb.Plugs.FormRequest, MyAppWeb.Requests.StoreTeamRequest
end
```

If you choose to use `perform/2` then the `validate_success` option provided in `plugs/form_request.ex` will be ignored for that request.

## Built in Validation Rules

Examples show input that would successfully validate. Some rules require a type to be specified first in order to properly validate.

- [comparison operators (==, >, >=, <, <=)](#comparison-operators)
- [between](#between)
- [cast](#cast)
- [characters](#characters)
- [date_string](#date_string)
- [digits_between](#digits_between)
- [digits](#digits)
- [ends_with](#ends_with)
- [in](#in)
- [ip/v4/v6](#ip)
- [lowercase](#lowercase)
- [max_digits](#max_digits)
- [max](#max)
- [min_digits](#min_digits)
- [min](#min)
- [not_ends_with](#not_ends_with)
- [not_in](#not_in)
- [not_regex](#not_regex)
- [not_starts_with](#not_starts_with)
- [nullable](#nullable)
- [regex](#regex)
- [required](#required)
- [size](#size)
- [starts_with](#starts_with)
- [type](#type)
- [uppercase](#uppercase)
- [url](#url)
- [uuid](#uuid)

### comparison operators

You can use atoms of `==`, `>`, `>=`, `<`, and `<=` to compare values.

Aside from primitive values you can compare Date, DateTime, and NaiveDateTime values.

```elixir
Validate.validate("bob", ==: "bob")

Validate.validate(~D[2020-02-15], >: ~D[2015-10-14])
```

### between

The field under validation must be between the two numbers (inclusive).

```elixir
Validate.validate(10, type: :number, between: {1, 20})
```

### cast

Trys to convert the field to the specified type. Can be used in place of the [`type`](#type) rule if you e.g. want a number as the end result but are taking input from an HTML form which is inputted as a string. Later validation rules and the resulting validated data will contain the casted value in the new type. Prevents further rules from running if validation fails.

Available types are: `:atom`, `:boolean`, `:float`, `:integer`, `:string`.

```elixir
Validate.validate("123", cast: :integer)
```

`nil` is converted to the appropriate "empty" value of the type:

- `:atom` -> `:""`
- `:boolean` -> `false`
- `:float` -> `0.0`
- `:integer` -> `0`
- `:string` -> `""`

If you'd like to preserve `nil` you must use the full syntax and pass the `:preserve` flag:

```elixir
Validate.validate(nil, cast: [to: :integer, nil: :preserve])
```

### characters

The field under validation must have a specific set of characters. Useful for things like usernames.

```elixir
# letters only
Validate.validate("LeslieKnope", type: :string, characters: :alpha)

# letters + numbers
Validate.validate("LeslieKnope123", type: :string, characters: :alpha_num)

# letters, numbers, dashes, underscores
Validate.validate("Leslie-Knope_123", type: :string, characters: :alpha_dash)
```

Each option also has an `_ascii` alternative available to restrict any non-ascii characters: `:alpha_ascii`, `:alpha_num_ascii`, `:alpha_dash_ascii`.

### date_string

The field under validation must be a string matching a valid Timex string format.

```elixir
Validate.validate("2020-02-10", date_string: "{YYYY}-{0M}-{0D}")
```

### digits_between

The field under validation must have a number of digits between the two numbers (inclusive).

```elixir
Validate.validate(100, type: :integer, digits_between: {2, 4})
```

### digits

The field under validation must have the exact amount of digits.

```elixir
Validate.validate(100, type: :integer, digits: 3)
```

### ends_with

The field under validation must end with the specified string.

```elixir
Validate.validate("exciting!", type: :string, ends_with: "!")
```

### in

The field under validation must be in the provided array.

```elixir
Validate.validate("blue", type: :string, in: ["red", "green", "blue"])
```

### ip

The field under validation must be a valid IP address.

```elixir
# allows v4 or v6
Validate.validate("127.0.0.1", type: :string, ip: true)

# v4 only
Validate.validate("127.0.0.1", type: :string, ip: :v4)

# v6 only
Validate.validate("3ffe:b80:1f8d:2:204:acff:fe17:bf3", type: :string, ip: :v6)
```

### lowercase

The field under validation must be all lowercase.

```elixir
Validate.validate("hello", type: :string, lowercase: true)
```

The field under validation must not be all lowercase.

```elixir
Validate.validate("Hello", type: :string, lowercase: false)
```

### list

The field under validation must be a list, and you must specify rules that should be ran for each item in the list.

```elixir
Validate.validate([1, 2, 3], list: [required: true, type: :number])
```

### map

The field under validation must be a map, and you must specify validation rules for the keys of the map.

```elixir
Validate.validate(%{"name" => "Jane"}, map: %{"name" => [required: true, type: :string]})

# you can also just pass a map directly as the second argument when the input is a map
Validate.validate(%{"name" => "Jane"}, %{"name" => [required: true, type: :string]})

# nesting also works
Validate.validate(%{
  "address" => %{
    "line1" => "123 Fake st"
  }
}, %{
  "address" => [
    map: %{
      "line1" => [
        required: true,
        type: :string
      ]
    }
  ]
})
```

### max_digits

The field under validation must be at most the provided number of digits.

```elixir
Validate.validate(10, type: :integer, max_digits: 2)
```

### max

The field under validation must be less than or equal to the provided number.

```elixir
Validate.validate(10, type: :number, max: 15)
```

### min_digits

The field under validation must be at least the provided number of digits.

```elixir
Validate.validate(10, type: :integer, min_digits: 2)
```

### min

The field under validation must be greater than or equal to the provided number.

```elixir
Validate.validate(10, type: :number, min: 1)
```

### not_ends_with

The field under validation must not end with the provided string.

```elixir
Validate.validate("exciting", type: :string, not_ends_with: "!")
```

### not_in

The field under validation must not be in the provided array.

```elixir
Validate.validate("black", type: :string, not_in: ["red", "green", "blue"])
```

### not_regex

The field under validation must not match the provided pattern.

```elixir
Validate.validate("abcd", type: :string, not_regex: ~r/[0-9]/)
```

### not_starts_with

The field under validation must not start with the provided string.

```elixir
Validate.validate("company_123", type: :string, not_starts_with: "user_")
```

### nullable

The field under validation can be `nil`. If the value is `nil`, it does not process any more rules for the field.

```elixir
# type & min do not run here
Validate.validate(nil, nullable: true, type: :string, min: 10)
```

### regex

The field under validation must match the provided pattern.

```elixir
Validate.validate("1234", type: :string, regex: ~r/[0-9]/)
```

### required

The field under validation must not be empty.

Empty values are `nil`, `""`, `%{}`, `[]`, `{}`.

```elixir
Validate.validate("red", required: true)
```

If set to `required: false`, empty values will be accepted.

```elixir
Validate.validate("", required: false)
```

This can be used as a "required if" by evaluating a statement to a boolean:

```elixir
Validate.validate("red", required: check_if_color_is_needed())
```

### size

The field under validation must have a size matching the given value.

- Numbers are compared directly to the value
- String sizes are calculated with `String.length/1`
- List and map sizes are calculated with `Enum.count/1`
- Tuple sizes are calculated with `tuple_size/1`

```elixir
Validate.validate("123", size: 3)
Validate.validate(10, size: 10)
Validate.validate([1, 2, 3], size: 3)
Validate.validate(%{ ok: true }, size: 1)
Validate.validate({1, 2}, size: 2)
```

### starts_with

The field under validation must start with the given value.

```elixir
Validate.validate("user_1234", type: :string, starts_with: "user_")
```

### type

The field under validation must be of the specified type.

Valid types are: `atom`, `binary`, `boolean`, `date`, `datetime`, `float`, `function`, `integer`, `list`, `map`, `naive_datetime`, `number`, `string`, `tuple`.

```elixir
Validate.validate(:user, type: :atom)
```

### uppercase

The field under validation must be all uppercase.

```elixir
Validate.validate("HELLO", type: :string, uppercase: true)
```

The field under validation must not be all uppercase.

```elixir
Validate.validate("hEllO", type: :string, uppercase: false)
```

### url

The field under validation must be a valid url. Evaluated using `URI.new/1` and requires that the url has scheme (such as `http://`).

```elixir
Validate.validate("https://example.com", type: :string, url: true)
```

### uuid

The field under validation must be a uuid.

```elixir
Validate.validate("123e4567-e89b-12d3-a456-426655440000", type: :string, uuid: true)
```
