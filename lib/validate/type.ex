defmodule Validate.Type do
  @moduledoc false

  alias Validate.Util
  import Validate.Validator

  def validate(%{value: value, arg: arg}) do
    expected = Atom.to_string(arg)
    received = Util.get_type(value)

    case validate_type(value, arg) do
      :error -> halt("expected #{expected} received #{received}")
      :ok -> success(value)
    end
  end

  defp validate_type(value, :atom) when not is_atom(value), do: :error
  defp validate_type(value, :binary) when not is_binary(value), do: :error
  defp validate_type(value, :boolean) when not is_boolean(value), do: :error
  defp validate_type(value, :float) when not is_float(value), do: :error
  defp validate_type(value, :function) when not is_function(value), do: :error
  defp validate_type(value, :list) when not is_list(value), do: :error
  defp validate_type(value, :map) when not is_map(value), do: :error
  defp validate_type(value, :number) when not is_number(value), do: :error
  defp validate_type(value, :string) when not is_bitstring(value), do: :error
  defp validate_type(value, :tuple) when not is_tuple(value), do: :error
  defp validate_type(_value, _type), do: :ok
end
