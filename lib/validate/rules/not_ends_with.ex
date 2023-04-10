defmodule Validate.Rules.NotEndsWith do
  @moduledoc false

  import Validate.Validator

  def validate(%{value: value, arg: str}) do
    case String.ends_with?(value, str) do
      true -> error("must not end with #{str}")
      false -> success(value)
    end
  end
end
