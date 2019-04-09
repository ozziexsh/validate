defmodule Consent.String do
  def string(val) when is_binary(val), do: {:ok, val}
  def string(val \\ nil), do: {:error, "not a string"}
end