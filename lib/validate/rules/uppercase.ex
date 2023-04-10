defmodule Validate.Rules.Uppercase do
  @moduledoc false

  import Validate.Validator

  def validate(%{value: value, arg: true}) do
    if String.upcase(value) == value do
      success(value)
    else
      error("must be in uppercase")
    end
  end

  def validate(%{value: value, arg: false}) do
    if String.upcase(value) == value do
      error("must not be in uppercase")
    else
      success(value)
    end
  end
end
