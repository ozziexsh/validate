defmodule Validate.NotStartsWith do
  @moduledoc false

  import Validate.Validator

  def validate(%{value: value, arg: str}) do
    case String.starts_with?(value, str) do
      true -> error("must not start with #{str}")
      false -> success(value)
    end
  end
end
