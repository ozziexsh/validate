defmodule Validate.Rules.Characters do
  @moduledoc false

  import Validate.Validator

  @alpha_ascii ~r/\A[a-zA-Z]+\z/u
  @alpha ~r/\A[\pL\pM]+\z/u
  @alpha_dash_ascii ~r/\A[a-zA-Z0-9_-]+\z/u
  @alpha_dash ~r/\A[\pL\pM\pN_-]+\z/u
  @alpha_num_ascii ~r/\A[a-zA-Z0-9]+\z/u
  @alpha_num ~r/\A[\pL\pM\pN]+\z/u

  def validate(%{value: value, arg: arg}) do
    regex = get_regex!(arg)

    if Regex.match?(regex, value) do
      success(value)
    else
      error(get_error(arg))
    end
  end

  defp get_error(arg) do
    cond do
      arg in [:alpha, :alpha_ascii] ->
        "must only contain letters"

      arg in [:alpha_dash, :alpha_dash_ascii] ->
        "must only contain letters, numbers, dashes, and underscores"

      arg in [:alpha_num, :alpha_num_ascii] ->
        "must only contain letters and numbers"
    end
  end

  defp get_regex!(arg) do
    case arg do
      :alpha_ascii -> @alpha_ascii
      :alpha -> @alpha
      :alpha_dash_ascii -> @alpha_dash_ascii
      :alpha_dash -> @alpha_dash
      :alpha_num_ascii -> @alpha_num_ascii
      :alpha_num -> @alpha_num
      _ -> raise("#{arg} is not a valid character set")
    end
  end
end
