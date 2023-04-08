defmodule Validate.EndsWith do
  @moduledoc false

  import Validate.Validator

  def validate(%{value: value, arg: str}) do
    case String.ends_with?(value, str) do
      true -> success(value)
      false -> error("must end with #{str}")
    end
  end
end
