defmodule Validate.Type do
  def validate(%{value: value, arg: arg}) do
    expected = Atom.to_string(arg)
    received = typeof(value)

    case validate_type(value, arg) do
      :error -> {:error, "expected #{expected} received #{received}"}
      :ok -> {:ok, value}
    end
  end

  defp validate_type(value, :string) when not is_bitstring(value), do: :error
  defp validate_type(value, :number) when not is_number(value), do: :error
  defp validate_type(value, :map) when not is_map(value), do: :error
  defp validate_type(value, :list) when not is_list(value), do: :error
  defp validate_type(value, :boolean) when not is_boolean(value), do: :error
  defp validate_type(_value, _type), do: :ok

  defp typeof(a) do
    cond do
      is_float(a) -> "float"
      is_number(a) -> "number"
      is_atom(a) -> "atom"
      is_boolean(a) -> "boolean"
      is_binary(a) -> "binary"
      is_function(a) -> "function"
      is_list(a) -> "list"
      is_tuple(a) -> "tuple"
      true -> "unknown"
    end
  end
end
