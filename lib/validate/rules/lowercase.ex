defmodule Validate.Rules.Lowercase do
  @moduledoc false

  import Validate.Validator

  def validate(%{value: value, arg: true}) do
    if String.downcase(value) == value do
      success(value)
    else
      error("must be in lowercase")
    end
  end

  def validate(%{value: value, arg: false}) do
    if String.downcase(value) == value do
      error("must not be in lowercase")
    else
      success(value)
    end
  end
end
