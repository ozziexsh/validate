defmodule Validate.Rules.Uuid do
  @moduledoc false

  import Validate.Validator

  # https://github.com/laravel/framework/blob/025c9128994eefd3351061a971c0bbc909680b37/src/Illuminate/Validation/Concerns/ValidatesAttributes.php#L2353
  @expr ~r/^[\da-f]{8}-[\da-f]{4}-[\da-f]{4}-[\da-f]{4}-[\da-f]{12}$/i

  def validate(%{value: value}) do
    if Regex.match?(@expr, value) do
      success(value)
    else
      error("not a valid uuid")
    end
  end
end
