defmodule Validate.Rules.Between do
  @moduledoc false

  import Validate.Validator

  def validate(%{value: value, arg: {min, max}}) do
    if value >= min and value <= max do
      success(value)
    else
      error("must be between #{min} and #{max}")
    end
  end
end
