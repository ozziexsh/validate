defmodule ValidateTest.Rules.DateStringTest do
  use ExUnit.Case
  doctest Validate.Rules.DateString
  alias Validate.Rules.DateString

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: "{YYYY}-{0M}-{0D}"
  }

  test "it validates dates" do
    assert DateString.validate(%{@input | value: "2020-10-15"}) == success("2020-10-15")

    assert DateString.validate(%{@input | value: "2020-15-10"}) ==
             error("must match the format of {YYYY}-{0M}-{0D}")
  end

  test "it validates date times" do
    assert DateString.validate(%{@input | arg: "{ISO:Extended}", value: "2020-10-15T10:15:20Z"}) ==
             success("2020-10-15T10:15:20Z")

    assert DateString.validate(%{@input | arg: "{ISO:Extended}", value: "2020-15-10"}) ==
             error("must match the format of {ISO:Extended}")
  end
end
