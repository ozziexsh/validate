defmodule Validate.Rules.LessThanEqual do
  @moduledoc false

  import Validate.Validator

  def validate(%{value: value, arg: arg}) do
    if handle(value, arg) do
      success(value)
    else
      error("must be less than or equal to #{arg}")
    end
  end

  def handle(value, arg) when is_struct(arg, Date) do
    Date.compare(value, arg) in [:lt, :eq]
  end

  def handle(value, arg) when is_struct(arg, DateTime) do
    DateTime.compare(value, arg) in [:lt, :eq]
  end

  def handle(value, arg) when is_struct(arg, NaiveDateTime) do
    NaiveDateTime.compare(value, arg) in [:lt, :eq]
  end

  def handle(value, arg) do
    value <= arg
  end
end
