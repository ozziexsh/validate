defmodule Validate.Rules.DateString do
  use Timex

  import Validate.Validator

  def validate(%{value: value, arg: format}) do
    try do
      Timex.parse!(value, format)
      success(value)
    rescue
      _ -> error("must match the format of #{format}")
    end
  end
end
