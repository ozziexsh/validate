defmodule Validate.NotRegex do
  @moduledoc false

  import Validate.Validator

  def validate(%{value: value, arg: pattern}) do
    if Regex.match?(pattern, value) do
      error("must not match pattern #{Regex.source(pattern)}")
    else
      success(value)
    end
  end
end
