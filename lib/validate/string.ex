defmodule Validate.String do
  def string() do
    fn value -> check(value) end
  end

  defp check(val) when is_binary(val), do: {:ok, val}
  defp check(_val), do: {:error, "not a string"}
end
