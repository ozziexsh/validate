defmodule Validate.Optional do
  def optional() do
    fn value -> check(value) end
  end

  defp check(nil), do: {:halt}
  defp check(val), do: {:ok, val}
end
