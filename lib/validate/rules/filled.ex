defmodule Validate.Rules.Filled do
  alias Validate.Util
  import Validate.Validator

  # todo: how is this different from required?

  def validate(%{value: value, arg: true}) do
    case Util.empty?(value) do
      false -> success(value)
      _ -> error("must be filled")
    end
  end

  def validate(%{value: value, arg: false}) do
    case Util.empty?(value) do
      true -> success(value)
      _ -> error("must not be filled")
    end
  end
end
