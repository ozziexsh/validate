defmodule Validate.In do
  import Validate.Validator

  def validate(%{value: value, arg: lookup}) do
    case value in lookup do
      true -> success(value)
      false -> error("must be one of #{Enum.join(lookup, ", ")}")
    end
  end
end
