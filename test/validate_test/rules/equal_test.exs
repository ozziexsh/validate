defmodule ValidateTest.Rules.EqualTest do
  use ExUnit.Case
  doctest Validate.Rules.Equal
  alias Validate.Rules.Equal

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: ""
  }

  test "it can be called from validate" do
    assert Validate.validate(10, ==: 10) == success(10)
  end

  test "it compares strings" do
    assert Equal.validate(%{@input | value: "1", arg: "1"}) == success("1")
    assert Equal.validate(%{@input | value: "1", arg: "2"}) == error("must equal 2")
  end

  test "it compares numbers" do
    assert Equal.validate(%{@input | value: 1, arg: 1}) == success(1)
    assert Equal.validate(%{@input | value: 1.10, arg: 1.10}) == success(1.10)
    assert Equal.validate(%{@input | value: 1, arg: 2}) == error("must equal 2")
  end

  test "it compares dates" do
    date = Timex.parse!("2020-02-15", "{YYYY}-{0M}-{0D}") |> Timex.to_date()
    wrong_date = Timex.parse!("2020-10-10", "{YYYY}-{0M}-{0D}") |> Timex.to_date()

    assert Equal.validate(%{@input | value: date, arg: date}) == success(date)

    assert Equal.validate(%{@input | value: wrong_date, arg: date}) ==
             error("must equal 2020-02-15")
  end

  test "it compares datetimes" do
    date = Timex.parse!("2020-02-15T10:15:20Z", "{ISO:Extended}") |> Timex.to_datetime()
    wrong_date = Timex.parse!("2020-10-20T10:15:20Z", "{ISO:Extended}") |> Timex.to_datetime()

    assert Equal.validate(%{@input | value: date, arg: date}) == success(date)

    assert Equal.validate(%{@input | value: wrong_date, arg: date}) ==
             error("must equal 2020-02-15 10:15:20Z")
  end

  test "it compares naive datetimes" do
    date = Timex.parse!("2020-02-15T10:15:20Z", "{ISO:Extended}") |> Timex.to_naive_datetime()

    wrong_date =
      Timex.parse!("2020-10-20T10:15:20Z", "{ISO:Extended}") |> Timex.to_naive_datetime()

    assert Equal.validate(%{@input | value: date, arg: date}) == success(date)

    assert Equal.validate(%{@input | value: wrong_date, arg: date}) ==
             error("must equal 2020-02-15 10:15:20")
  end
end
