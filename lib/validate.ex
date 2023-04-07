defmodule Validate do
  @moduledoc """
  Validate, validate incoming requests in an easy to reason-about way.
  """
  alias Validate.Validator.{Error, Arg}

  @fn_map %{
    ends_with: &Validate.EndsWith.validate/1,
    in: &Validate.In.validate/1,
    max: &Validate.Max.validate/1,
    min: &Validate.Min.validate/1,
    not_in: &Validate.NotIn.validate/1,
    nullable: &Validate.Nullable.validate/1,
    required: &Validate.Required.validate/1,
    size: &Validate.Size.validate/1,
    starts_with: &Validate.StartsWith.validate/1,
    type: &Validate.Type.validate/1
  }

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
    handler = if opts.rule == :custom, do: opts.arg, else: Map.get(@fn_map, opts.rule)

    result = handler.(%Arg{value: opts.value, arg: opts.arg, input: opts.input})

    path = if opts.valueName != nil, do: [opts.valueName], else: []
    path = opts.path ++ path

    case result do
      {code, reason} when code in [:error, :halt] ->
        {code, opts.value, [%Error{path: path, rule: opts.rule, message: reason}]}

      {:halt} ->
        {:ok, opts.value, []}

      {:ok, value} ->
        {:ok, value, []}
    end
  end
end
