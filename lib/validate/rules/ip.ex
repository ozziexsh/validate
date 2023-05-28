defmodule Validate.Rules.Ip do
  @moduledoc false

  import Validate.Validator

  @error "not a valid ip address"
  @error_v4 "not a valid ipv4 address"
  @error_v6 "not a valid ipv6 address"

  def validate(%{value: value, arg: arg}) do
    validate_arg!(arg)

    case :inet.parse_address(to_charlist(value)) do
      {:ok, parsed} ->
        validate_by_arg(arg, parsed, value)

      _ ->
        case arg do
          true -> error(@error)
          :v4 -> error(@error_v4)
          :v6 -> error(@error_v6)
        end
    end
  end

  defp validate_by_arg(true, _parsed, value), do: success(value)

  defp validate_by_arg(:v4, parsed, value) do
    if :inet.is_ipv4_address(parsed) do
      success(value)
    else
      error(@error_v4)
    end
  end

  defp validate_by_arg(:v6, parsed, value) do
    if :inet.is_ipv6_address(parsed) do
      success(value)
    else
      error(@error_v6)
    end
  end

  defp validate_arg!(arg) when arg not in [true, :v4, :v6],
    do: raise("#{arg} is not a valid option for the ip validator")

  defp validate_arg!(_arg), do: true
end
