defmodule Validate.Required do
  def validate(%{value: value}) do
    case validate_required(value) do
      :error -> {:error, "is required"}
      :ok -> {:ok, value}
    end
  end

  defp validate_required([]), do: :error
  defp validate_required(""), do: :error
  defp validate_required(map) when map == %{}, do: :error
  defp validate_required(nil), do: :error
  defp validate_required({}), do: :error
  defp validate_required(_value), do: :ok
end
