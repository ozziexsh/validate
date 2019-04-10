defmodule Consent.List do
  def list(val) when is_list(val), do: {:ok, val}
  def list(val \\ nil), do: {:error, "not a list"}
end
