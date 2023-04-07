defmodule Validate.Max do
  alias Validate.Util
  import Validate.Validator

  def validate(%{value: value, arg: max}) do
    message = "must be at most #{max}"

    case Util.get_size(value) do
      size when is_number(size) -> if size > max, do: error(message), else: success(value)
      _ -> error(message)
    end
  end
end
