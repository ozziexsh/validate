defmodule Validate.List do
  def list() do
    fn value -> check(value) end
  end

  defp check(val) when is_list(val), do: {:ok, val}
  defp check(_val), do: {:error, "not a list"}
end
