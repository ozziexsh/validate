defmodule Validate.List do
  def list(_val \\ nil)
  def list(val) when is_list(val), do: {:ok, val}
  def list(_val), do: {:error, "not a list"}
end
