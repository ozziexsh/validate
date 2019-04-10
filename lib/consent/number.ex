defmodule Consent.Number do
  def number(val) when is_integer(val) or is_float(val), do: {:ok, val}
  def number(val \\ nil), do: {:error, "not a number"}
end
