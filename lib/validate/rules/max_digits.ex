defmodule Validate.Rules.MaxDigits do
  @moduledoc false

  import Validate.Validator

  def validate(%{value: value, arg: digits}) do
    count = value |> Integer.digits() |> Enum.count()

    if count <= digits do
      success(value)
    else
      error("must be at most #{digits} digits long")
    end
  end
end
