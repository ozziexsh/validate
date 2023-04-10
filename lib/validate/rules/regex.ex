defmodule Validate.Rules.Regex do
  @moduledoc false

  import Validate.Validator

  def validate(%{value: value, arg: pattern}) do
    if Regex.match?(pattern, value) do
      success(value)
    else
      error("must match pattern #{Regex.source(pattern)}")
    end
  end
end
