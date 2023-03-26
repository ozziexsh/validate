defmodule Validate.Type do
  def validate(%{value: value, arg: arg}) do
    case validate_type(value, arg) do
      :error -> {:error, "invalid type"}
      :ok -> {:ok, value}
    end
  end

  defp validate_type(value, :string) when not is_bitstring(value), do: :error
  defp validate_type(value, :number) when not is_number(value), do: :error
  defp validate_type(value, :map) when not is_map(value), do: :error
  defp validate_type(value, :list) when not is_list(value), do: :error
  defp validate_type(value, :boolean) when not is_boolean(value), do: :error
  defp validate_type(_value, _type), do: :ok
end
