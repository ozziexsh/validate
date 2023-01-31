defmodule Validate.Number do
  def number() do
    fn value -> check(value) end
  end

  defp check(val) when is_integer(val) or is_float(val), do: {:ok, val}
  defp check(_val), do: {:error, "not a number"}
end
