defmodule Validate.Rules.StartsWith do
  @moduledoc false

  import Validate.Validator

  def validate(%{value: value, arg: str}) do
    case String.starts_with?(value, str) do
      true -> success(value)
      false -> error("must start with #{str}")
    end
  end
end
