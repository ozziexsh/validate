defmodule Validate.Validator do
  @moduledoc """
  Provides the Error and Arg structs, as well as helpers for validation responses
  """

  defmodule Error do
    @moduledoc false
    defstruct path: [], message: "", rule: nil
  end

  defmodule Arg do
    @moduledoc false
    defstruct value: nil, arg: nil, input: nil
  end

  @doc """
  Used in validators to return an error with a message
  """
  def error(message), do: {:error, message}

  @doc """
  Used in validators to prevent further validation for a field while also adding an error message
  """
  def halt(message), do: {:halt, message}

  @doc """
  Used in validators to prevent further validation for a field but treated as a success
  """
  def halt(), do: {:halt}

  @doc """
  Used in validators to indicate validation was successful for a field
  """
  def success(value), do: {:ok, value}
end
