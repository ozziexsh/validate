defmodule Validate.Validator do
  defmodule Error do
    defstruct path: [], message: "", rule: nil
  end

  defmodule Arg do
    defstruct value: nil, arg: nil, input: nil
  end

  def error(message), do: {:error, message}

  def success(value), do: {:ok, value}
end
