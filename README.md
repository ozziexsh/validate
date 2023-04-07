# Validate

Validate data in elixir. Focused on validating incoming http request data but works with all elixir data types.

Coming from languages like PHP and Node.js it can be difficult to reason about validating your requests using Ecto. This provides a simple data validation layer that aims to be extensible to allow for custom validation logic provided by the user.

Inspired by Laravel's validator.

## Features

- [x] Simple (raw string, bool, etc), nested maps, and list validation
- [x] 10 built in validators (more coming soon)
- [x] Custom validators
- [x] Return validated keys only
- [ ] i18n

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
  - [Simple Validation](#simple-validation)
  - [Map Validation](#map-validation)
  - [Nested Rules](#nested-rules)
- [Errors](#errors)
  - [Formatting Errors](#formatting-errors)
- [Built in Validators](#built-in-validators)

## Installation

Add Validate to your mix.exs dependencies:

```elixir
defp deps do
  [
    {:validate, "~> 1.0"}
  ]
end
```

## Usage

The basic usage looks like:

```elixir
# data is the validatede input
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

## Built in Validators

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

### max

The field under validation must be less than or equal to the provided number.

```elixir
Validate.validate(10, type: :number, max: 15)
```

### min

The field under validation must be greater than or equal to the provided number.

```elixir
Validate.validate(10, type: :number, min: 1)
```

### not_in

The field under validation must not be in the provided array.

```elixir
Validate.validate("black", type: :string, not_in: ["red", "green", "blue"])
```

### nullable

The field under validation can be `nil`. If the value is `nil`, it does not process any more rules for the field.

```elixir
# type & min do not run here
Validate.validate(nil, nullable: true, type: :string, min: 10)
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

Valid types are: `atom`, `binary`, `boolean`, `float`, `function`, `list`, `map`, `number`, `string`, `tuple`.

```elixir
Validate.validate(:user, type: :atom)
```
