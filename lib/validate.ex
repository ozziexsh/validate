defmodule Validate do
  @moduledoc """
  Validate, validate incoming requests in an easy to reason-about way.
  """
  alias Validate.Validator.{Error, Arg}

  @fn_map %{
    required: &Validate.Required.validate/1,
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
    Enum.reduce(opts.rules, {opts.value, []}, fn {ruleName, ruleArg}, {value, allErrors} ->
      {data, errors} =
        run_validator_rule(%{
          rule: ruleName,
          arg: ruleArg,
          value: value,
          valueName: opts.valueName,
          rules: opts.rules,
          input: opts.input,
          path: opts.path
        })

      cond do
        Enum.count(errors) > 0 -> {data, allErrors ++ errors}
        true -> {data, allErrors}
      end
    end)
  end

  defp run_validator_rule(%{rule: :list, arg: rulesForList} = opts) do
    opts.value
    |> Enum.with_index()
    |> Enum.reduce({[], []}, fn {item, i}, {value, allErrors} ->
      {data, errors} =
        validate_single_input(%{
          value: item,
          valueName: i,
          rules: rulesForList,
          input: opts.input,
          path: opts.path ++ [opts.valueName]
        })

      cond do
        Enum.count(errors) > 0 -> {value, allErrors ++ errors}
        true -> {value ++ [data], allErrors}
      end
    end)
  end

  defp run_validator_rule(%{rule: :map, arg: rulesForMap} = opts) do
    rulesForMap
    |> Enum.reduce({%{}, []}, fn {subKey, subRules}, {filteredValue, allErrors} ->
      {data, errors} =
        validate_single_input(%{
          value: Map.get(opts.value, subKey),
          valueName: subKey,
          rules: subRules,
          input: opts.input,
          path: opts.path ++ [opts.valueName]
        })

      cond do
        Enum.count(errors) > 0 -> {filteredValue, allErrors ++ errors}
        true -> {Map.put(filteredValue, subKey, data), allErrors}
      end
    end)
  end

  defp run_validator_rule(opts) do
    handler = if opts.rule == :custom, do: opts.arg, else: Map.get(@fn_map, opts.rule)

    result = handler.(%Arg{value: opts.value, arg: opts.arg, input: opts.input})

    path = if opts.valueName != nil, do: [opts.valueName], else: []
    path = opts.path ++ path

    case result do
      {:error, reason} ->
        {opts.value, [%Error{path: path, rule: opts.rule, message: reason}]}

      {:ok, value} ->
        {value, []}
    end
  end
end
