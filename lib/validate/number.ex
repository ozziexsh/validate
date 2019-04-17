defmodule Validate.Number do
  def number(_val \\ nil)
  def number(val) when is_integer(val) or is_float(val), do: {:ok, val}
  def number(_val), do: {:error, "not a number"}
end
