defmodule Consent do
  @moduledoc """
  Consent, validate incoming requests in an easy to reason-about way.
  """

  @doc """
  Consent.validate/2, the entry point for validation.
  Takes in a struct. Returns either:
  `{:ok, data}` or `{:error, errors}`
  Data returned is filtered out to only keys provided in rules
  """
  def validate(params, rules) do
    {data, errors} =
      Enum.reduce(rules, {%{}, %{}}, fn {key, item_rules}, {data, errors} ->
        value = Map.get(params, key)
        res = Enum.reduce(item_rules, {:ok, nil}, &evaluate_validator(value, &1, &2))

        case res do
          {:ok, x} ->
            {Map.put(data, key, x), errors}

          {:error, msg} ->
            {data, Map.put(errors, key, msg)}
          
          {:skip} -> {data, errors}
        end
      end)

    result(data, errors)
  end

  defp evaluate_validator(_value, _validator, {:skip} = acc), do: acc
  defp evaluate_validator(value, validator, _acc) do
    validator.(value)
  end

  defp result(data, errors) do
    case Enum.count(errors) do
      0 ->
        {:ok, data}

      _ ->
        {:error, errors}
    end
  end
end
