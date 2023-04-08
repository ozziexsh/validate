defmodule Validate.Nullable do
  @moduledoc false

  import Validate.Validator

  def validate(%{value: nil, arg: true}), do: halt()
  def validate(%{value: value, arg: true}), do: success(value)
  def validate(%{value: nil, arg: false}), do: error("must not be nil")
  def validate(%{value: value, arg: false}), do: success(value)
end
