defmodule Validate.Map do
  def map(_val \\ nil)
  def map(val) when is_map(val), do: {:ok, val}
  def map(_val), do: {:error, "not a map"}
end
