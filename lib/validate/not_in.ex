defmodule Validate.NotIn do
  @moduledoc false

  import Validate.Validator

  def validate(%{value: value, arg: lookup}) do
    case value not in lookup do
      true -> success(value)
      false -> error("must not be one of #{Enum.join(lookup, ", ")}")
    end
  end
end
