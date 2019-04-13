defmodule Validate.Optional do
  def optional(nil), do: {:skip}
  def optional(val), do: {:ok, val}
end
