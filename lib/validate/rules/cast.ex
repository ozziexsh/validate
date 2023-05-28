defmodule Validate.Rules.Cast do
  @moduledoc false
  alias Validate.Util

  import Validate.Validator

  def validate(%{arg: new_type} = opts) when is_atom(new_type) do
    validate(%{opts | arg: [to: new_type]})
  end

  def validate(%{arg: date_args} = opts) when is_tuple(date_args) do
    validate(%{opts | arg: [to: date_args]})
  end

  def validate(%{value: value, arg: options}) do
    preserve_nil? = Keyword.get(options, nil, :convert) == :preserve
    new_type = Keyword.get(options, :to)

    if preserve_nil? && is_nil(value) do
      success(nil)
    else
      try do
        converted = convert!(new_type, value)
        success(converted)
      rescue
        _ ->
          type_string = if is_tuple(new_type), do: elem(new_type, 0), else: new_type
          halt("could not cast to #{type_string}")
      end
    end
  end

  defp convert!(:atom, value) do
    value |> to_string() |> String.to_atom()
  end

  defp convert!(:boolean, value) do
    if value, do: true, else: false
  end

  defp convert!(:float, value) do
    case Util.get_type(value) do
      "integer" ->
        value + 0.0

      "float" ->
        value

      "nil" ->
        0.0

      _ ->
        {parsed, _extra} = Float.parse(value)
        parsed
    end
  end

  defp convert!(:integer, value) do
    case Util.get_type(value) do
      "float" ->
        trunc(value)

      "integer" ->
        value

      "nil" ->
        0

      _ ->
        {parsed, _extra} = Integer.parse(value)
        parsed
    end
  end

  defp convert!(:string, value) do
    to_string(value)
  end

  defp convert!({:date, format}, value) do
    Timex.parse!(value, format) |> Timex.to_date()
  end

  defp convert!({:naive_datetime, format}, value) do
    Timex.parse!(value, format) |> Timex.to_naive_datetime()
  end

  defp convert!({:datetime, format}, value) do
    Timex.parse!(value, format) |> Timex.to_datetime()
  end
end
