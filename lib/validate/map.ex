defmodule Validate.Map do
  def map() do
    fn value -> check(value) end
  end

  defp check(val) when is_map(val), do: {:ok, val}
  defp check(_val), do: {:error, "not a map"}
end
