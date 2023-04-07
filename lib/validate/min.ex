defmodule Validate.Min do
  alias Validate.Util
  import Validate.Validator

  def validate(%{value: value, arg: min}) do
    message = "must be at least #{min}"

    case Util.get_size(value) do
      size when is_number(size) -> if size >= min, do: success(value), else: error(message)
      _ -> error(message)
    end
  end
end
