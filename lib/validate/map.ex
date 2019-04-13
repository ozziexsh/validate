defmodule Validate.Map do
  def map(val) when is_map(val), do: {:ok, val}
  def map(val \\ nil), do: {:error, "not a map"}
end
