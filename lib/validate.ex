defmodule Validate do
  @moduledoc """
  Validate, validate incoming requests in an easy to reason-about way.
  """
  alias Validate.Validator.{Error, Arg}

  @fns ~w[between cast characters date_string digits_between digits ends_with filled in ip json lowercase max_digits max min_digits min not_ends_with not_in not_regex not_starts_with nullable regex required size starts_with type uppercase url uuid]

  @doc """
  Validates an input against a given list of rules

  ## Examples

      iex> {:ok, _data} = Validate.validate("Jane", required: true, type: :string)
      iex> {:error, _errors} = Validate.validate([], required: true, type: :list)
      iex> {:ok, _data} = Validate.validate(%{"name" => "Jane"}, %{"name" => [required: true, type: :string]})
  """
  def validate(input, rules) when is_list(rules) do
    {input, errors} =
      validate_single_input(%{
        value: input,
        valueName: nil,
        rules: rules,
        input: input,
        path: []
      })

    cond do
      Enum.count(errors) > 0 -> {:error, errors}
      true -> {:ok, input}
    end
  end

  def validate(input, rules) do
    {input, errors} =
      Enum.reduce(rules, {%{}, []}, fn {inputName, ruleList}, {filteredInput, finalErrors} ->
        inputValue = Map.get(input, inputName)

        {inputValue, inputErrors} =
          validate_single_input(%{
            value: inputValue,
            valueName: inputName,
            rules: ruleList,
            input: input,
            path: []
          })

        cond do
          Enum.count(inputErrors) > 0 -> {filteredInput, finalErrors ++ inputErrors}
          true -> {Map.put(filteredInput, inputName, inputValue), finalErrors}
        end
      end)

    cond do
      Enum.count(errors) > 0 -> {:error, errors}
      true -> {:ok, input}
    end
  end

  defp validate_single_input(opts) do
    {_, value, errors} =
      Enum.reduce(opts.rules, {:ok, opts.value, []}, fn {ruleName, ruleArg},
                                                        {continue, value, allErrors} ->
        case continue do
          :halt ->
            {continue, value, allErrors}

          _ ->
            {code, data, errors} =
              run_validator_rule(%{
                rule: ruleName,
                arg: ruleArg,
                value: value,
                valueName: opts.valueName,
                rules: opts.rules,
                input: opts.input,
                path: opts.path
              })

            {code, data, allErrors ++ errors}
        end
      end)

    {value, errors}
  end

  defp run_validator_rule(%{rule: :list, arg: rulesForList} = opts) do
    opts.value
    |> Enum.with_index()
    |> Enum.reduce({:ok, [], []}, fn {item, i}, {_, value, allErrors} ->
      {data, errors} =
        validate_single_input(%{
          value: item,
          valueName: i,
          rules: rulesForList,
          input: opts.input,
          path: opts.path ++ [opts.valueName]
        })

      cond do
        Enum.count(errors) > 0 -> {:error, value, allErrors ++ errors}
        true -> {:ok, value ++ [data], allErrors}
      end
    end)
  end

  defp run_validator_rule(%{rule: :map, arg: rulesForMap} = opts) do
    rulesForMap
    |> Enum.reduce({:ok, %{}, []}, fn {subKey, subRules}, {_, filteredValue, allErrors} ->
      path = if opts.valueName != nil, do: [opts.valueName], else: []
      path = opts.path ++ path

      {data, errors} =
        validate_single_input(%{
          value: Map.get(opts.value, subKey),
          valueName: subKey,
          rules: subRules,
          input: opts.input,
          path: path
        })

      cond do
        Enum.count(errors) > 0 -> {:error, filteredValue, allErrors ++ errors}
        true -> {:ok, Map.put(filteredValue, subKey, data), allErrors}
      end
    end)
  end

  defp run_validator_rule(opts) do
    handler = get_handler(opts)

    result = handler.(%Arg{value: opts.value, arg: opts.arg, input: opts.input})

    path = if opts.valueName != nil, do: [opts.valueName], else: []
    path = opts.path ++ path

    case result do
      {code, reason} when code in [:error, :halt] ->
        {code, opts.value, [%Error{path: path, rule: opts.rule, message: reason}]}

      {:halt} ->
        {:halt, opts.value, []}

      {:ok, value} ->
        {:ok, value, []}
    end
  end

  defp get_handler(%{rule: :custom, arg: arg}), do: arg

  defp get_handler(%{rule: :>}), do: &Validate.Rules.GreaterThan.validate/1
  defp get_handler(%{rule: :>=}), do: &Validate.Rules.GreaterThanEqual.validate/1
  defp get_handler(%{rule: :<}), do: &Validate.Rules.LessThan.validate/1
  defp get_handler(%{rule: :<=}), do: &Validate.Rules.LessThanEqual.validate/1
  defp get_handler(%{rule: :==}), do: &Validate.Rules.Equal.validate/1

  defp get_handler(%{rule: rule}) do
    rule_str = Atom.to_string(rule)

    if rule_str in @fns do
      module = "Elixir.Validate.Rules.#{Macro.camelize(rule_str)}" |> String.to_existing_atom()

      &module.validate/1
    else
      raise "#{rule} validator does not exist"
    end
  end
end
