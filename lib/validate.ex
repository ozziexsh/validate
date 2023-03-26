defmodule Validate do
  @moduledoc """
  Validate, validate incoming requests in an easy to reason-about way.
  """

  @fn_map %{
    required: &Validate.Required.validate/1,
    type: &Validate.Type.validate/1
  }

  def validate(input, rules) do
    {input, errors} =
      Enum.reduce(rules, {%{}, []}, fn {inputName, ruleList}, {filteredInput, finalErrors} ->
        inputValue = Map.get(input, inputName)

        {inputValue, inputErrors} =
          Enum.reduce(ruleList, {inputValue, []}, fn {ruleName, ruleArg}, {data, errors} ->
            handler = Map.get(@fn_map, ruleName)

            result = handler.(%{value: data, arg: ruleArg, rules: ruleList, input: input})

            case result do
              {:error, reason} ->
                {data, [%{path: [inputName], rule: ruleName, message: reason} | errors]}

              {:ok, value} ->
                {value, errors}
            end
          end)

        cond do
          Enum.count(inputErrors) > 0 -> {filteredInput, inputErrors ++ finalErrors}
          true -> {Map.put(filteredInput, inputName, inputValue), finalErrors}
        end
      end)

    cond do
      Enum.count(errors) > 0 -> {:error, errors}
      true -> {:ok, input}
    end
  end
end
