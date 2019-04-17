defmodule Validate.String do
  def string(_val \\ nil)
  def string(val) when is_binary(val), do: {:ok, val}
  def string(_val), do: {:error, "not a string"}
end
