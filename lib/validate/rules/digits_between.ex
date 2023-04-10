defmodule Validate.Rules.DigitsBetween do
  @moduledoc false

  import Validate.Validator

  def validate(%{value: value, arg: {min, max}}) do
    count = value |> Integer.digits() |> Enum.count()

    if count >= min and count <= max do
      success(value)
    else
      error("must be between #{min} and #{max} digits")
    end
  end
end
