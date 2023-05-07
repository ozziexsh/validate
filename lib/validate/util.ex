defmodule Validate.Util do
  @moduledoc """
  Utilities to help with validation
  """

  @doc false
  def get_size(value) when is_number(value), do: value
  def get_size(value) when is_bitstring(value), do: String.length(value)
  def get_size(value) when is_list(value) or is_map(value), do: Enum.count(value)
  def get_size(value) when is_tuple(value), do: tuple_size(value)
  def get_size(_value), do: nil

  @doc false
  def get_type(a) do
    cond do
      is_nil(a) -> "nil"
      is_atom(a) -> "atom"
      is_binary(a) -> "binary"
      is_boolean(a) -> "boolean"
      is_float(a) -> "float"
      is_integer(a) -> "integer"
      is_list(a) -> "list"
      is_map(a) -> "map"
      is_number(a) -> "number"
      is_bitstring(a) -> "string"
      is_function(a) -> "function"
      is_tuple(a) -> "tuple"
      true -> "unknown"
    end
  end

  @doc """
  Turns an array of %Validate.Validator.Error{} structs into a keyed map of errors

  ## Examples

      iex> {:error, errors} = Validate.validate(%{"name" => ""}, %{"name" => [required: true]})
      iex> %{"name" => ["is required"]} == Validate.Util.errors_to_map(errors)
  """
  def errors_to_map(errors) do
    Enum.reduce(errors, %{}, fn error, acc ->
      key = Enum.join(error.path, ".")
      existing = Map.get(acc, key, [])

      Map.put(acc, key, existing ++ [error.message])
    end)
  end
end
