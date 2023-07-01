defmodule Validate.Rules.Required do
  @moduledoc false
  alias Validate.Util

  import Validate.Validator

  def validate(%{value: value, arg: true}) do
    case Util.empty?(value) do
      true -> halt("is required")
      _ -> success(value)
    end
  end

  def validate(%{value: value, arg: false}) do
    success(value)
  end
end
