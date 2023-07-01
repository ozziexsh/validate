defmodule Validate.Rules.Json do
  import Validate.Validator

  defmodule JsonStub do
    def decode(str) do
      # todo swap w real impl
      if String.starts_with?(str, "{") do
        {:ok, str}
      else
        {:error, "invalid"}
      end
    end
  end

  def validate(%{value: value}) do
    case JsonStub.decode(value) do
      {:ok, _} -> success(value)
      _ -> error("not a valid json string")
    end
  end
end
