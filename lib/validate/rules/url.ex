defmodule Validate.Rules.Url do
  @moduledoc false

  import Validate.Validator

  def validate(%{value: value}) do
    case URI.new(value) do
      {:ok, %{scheme: nil}} ->
        error("must contain scheme")

      {:error, _} ->
        error("not a valid url")

      {:ok, _} ->
        success(value)
    end
  end
end
