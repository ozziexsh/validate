defmodule Validate.Size do
  alias Validate.Util
  import Validate.Validator

  def validate(%{value: value, arg: size}) do
    message = "must have a size of exactly #{size}"

    case Util.get_size(value) do
      x when is_number(x) -> if value == size, do: success(value), else: error(message)
      _ -> error(message)
    end
  end
end
