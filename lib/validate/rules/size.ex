defmodule Validate.Rules.Size do
  @moduledoc false

  alias Validate.Util
  import Validate.Validator

  def validate(%{value: value, arg: size}) do
    message = "must have a size of exactly #{size}"

    case Util.get_size(value) do
      x when is_number(x) and x == size -> success(value)
      _ -> error(message)
    end
  end
end
