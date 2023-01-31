defmodule Validate.Required do
  @moduledoc """
  Validate.required/1. Validates the presence of a value.
  If it's a string, checks that it's not empty
  If it's a list, checks that it has at least one item
  If it's a map, checks that it has at least one property
  """

  def required() do
    fn value -> check(value) end
  end

  defp check(val) when is_binary(val) do
    case String.length(val) do
      0 -> error()
      _ -> success(val)
    end
  end

  defp check(val) when is_list(val) or is_map(val) do
    case Enum.count(val) do
      0 -> error()
      _ -> success(val)
    end
  end

  defp check(val) do
    case val do
      nil -> error()
      _ -> success(val)
    end
  end

  defp error, do: {:halt, "required"}
  defp success(val), do: {:ok, val}
end
