defmodule Validate do
  @moduledoc """
  Validate incoming requests in an easy to reason-about way.
  """

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
        res = Enum.reduce(item_rules, {:ok, nil}, &run_validator(key, value, &1, &2))

        case res do
          {:ok, x} ->
            {Map.put(data, key, x), errors}

          {:error, msg} ->
            {data, Map.put(errors, key, msg)}

          {:merge, nested_errors} ->
            {data, Map.merge(errors, nested_errors)}

          {n, msg} when n in [:skip, :halt] ->
            {data, Map.put(errors, key, msg)}

          {n} when n in [:skip, :halt] ->
            {data, errors}
        end
      end)

    result(data, errors)
  end

  # When a validator says skip we want to forward along the skip param
  # so that the rest of the validators dont fire
  defp run_validator(_key, _value, _validator, {n} = acc) when n in [:skip, :halt], do: acc

  defp run_validator(_key, _value, _validator, {n, _msg} = acc) when n in [:skip, :halt], do: acc

  # Handles `:atom` keys in rule lists
  defp run_validator(_key, value, validator, _acc) when is_atom(validator) do
    if Map.has_key?(function_map(), validator) do
      Map.get(function_map(), validator).(value)
    else
      {:error, "invalid validator"}
    end
  end

  defp run_validator(key, value, {:list, rules}, _acc) when is_list(value) and is_map(rules) do
    results = Enum.map(value, fn item -> validate(item, rules) end)

    has_errors =
      results
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {item, index}, acc ->
        case item do
          {:ok, _} ->
            acc

          {:error, errors} ->
            Enum.reduce(errors, acc, fn {k, v}, nested_acc ->
              Map.put(nested_acc, :"#{key}.#{index}.#{k}", v)
            end)
        end
      end)

    case Enum.empty?(has_errors) do
      true -> {:ok, Enum.map(results, fn {:ok, data} -> data end)}
      false -> {:merge, has_errors}
    end
  end

  defp run_validator(key, value, {:list, rules}, _acc) when is_list(value) and is_list(rules) do
    results = Enum.map(value, fn item -> validate(%{item: item}, %{item: rules}) end)

    has_errors =
      results
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {item, index}, acc ->
        case item do
          {:ok, _} -> acc
          {:error, errors} -> Map.put(acc, :"#{key}.#{index}", errors.item)
        end
      end)

    case Enum.empty?(has_errors) do
      true -> {:ok, Enum.map(results, fn {:ok, data} -> data end)}
      false -> {:merge, has_errors}
    end
  end

  defp run_validator(_key, value, {:list, _rules}, _acc) do
    Map.get(function_map(), :list).(value)
  end

  # When a `[map: %{}]` is passed in a rule list, we want to just call
  # the same `validate` function on the map so it gets handled the same
  defp run_validator(key, value, {:map, nested_rules}, _acc) do
    if is_map(value) and is_map(nested_rules) do
      case validate(value, nested_rules) do
        {:error, errors} ->
          flattened =
            Enum.reduce(errors, %{}, fn {k, v}, acc ->
              Map.put(acc, :"#{key}.#{k}", v)
            end)

          {:merge, flattened}

        res ->
          res
      end
    else
      Map.get(function_map(), :map).(value)
    end
  end

  # Handles custom validators passed via function reference
  defp run_validator(_key, value, validator, _acc), do: validator.(value)

  defp result(data, errors) when map_size(errors) == 0, do: {:ok, data}
  defp result(_data, errors), do: {:error, errors}

  defp function_map(),
    do: %{
      required: Validate.Required.required(),
      optional: Validate.Optional.optional(),
      string: Validate.String.string(),
      number: Validate.Number.number(),
      list: Validate.List.list(),
      map: Validate.Map.map()
    }
end
