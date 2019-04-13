defmodule Validate do
  @moduledoc """
  Validate, validate incoming requests in an easy to reason-about way.
  """

  @fn_map %{
    :required => &Validate.Required.required/1,
    :optional => &Validate.Optional.optional/1,
    :string => &Validate.String.string/1,
    :number => &Validate.Number.number/1,
    :list => &Validate.List.list/1,
    :map => &Validate.Map.map/1
  }

  @doc """
  Validate.validate/2, the entry point for validation.
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

          {:skip, msg} ->
            {data, Map.put(errors, key, msg)}

          {:skip} ->
            {data, errors}
        end
      end)

    result(data, errors)
  end

  defp evaluate_validator(_value, _validator, {:skip} = acc), do: acc
  defp evaluate_validator(_value, _validator, {:skip, msg} = acc), do: acc

  defp evaluate_validator(value, validator, _acc) when is_atom(validator) do
    if Map.has_key?(@fn_map, validator) do
      Map.get(@fn_map, validator).(value)
    else
      {:error, "invalid validator"}
    end
  end

  defp evaluate_validator(value, {:map, nested_rules}, _acc) do
    if is_map(value) and is_map(nested_rules) do
      validate(value, nested_rules)
    else
      Map.get(@fn_map, :map).(value)
    end
  end

  defp evaluate_validator(value, validator, _acc), do: validator.(value)

  defp result(data, errors) when map_size(errors) == 0, do: {:ok, data}
  defp result(data, errors), do: {:error, errors}
end
