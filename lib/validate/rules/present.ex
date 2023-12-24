defmodule Validate.Rules.Present do
  import Validate.Validator

  def validate(%{value: value, arg: true} = opts) do
    parent = Map.get(opts, :parent, %{})

    if Map.has_key?(parent, opts.name) do
      success(value)
    else
      halt("must be present")
    end
  end

  def validate(%{arg: false} = opts) do
    parent = Map.get(opts, :parent, %{})

    if Map.has_key?(parent, opts.name) do
      halt("must not be present")
    else
      ignore()
    end
  end
end
