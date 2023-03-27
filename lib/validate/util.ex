defmodule Validate.Util do
  def get_size(value) when is_number(value), do: value
  def get_size(value) when is_bitstring(value), do: String.length(value)
  def get_size(value) when is_list(value) or is_map(value), do: Enum.count(value)
  def get_size(value) when is_tuple(value), do: tuple_size(value)
  def get_size(_value), do: nil

  def get_type(a) do
    cond do
      is_atom(a) -> "atom"
      is_binary(a) -> "binary"
      is_boolean(a) -> "boolean"
      is_float(a) -> "float"
      is_list(a) -> "list"
      is_map(a) -> "map"
      is_number(a) -> "number"
      is_bitstring(a) -> "string"
      is_function(a) -> "function"
      is_tuple(a) -> "tuple"
      true -> "unknown"
    end
  end
end
