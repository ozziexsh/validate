defmodule ValidateTest.Rules.GreaterThanTest do
  use ExUnit.Case
  doctest Validate.Rules.GreaterThan
  alias Validate.Rules.GreaterThan

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: ""
  }

  test "it can be called from validate" do
    assert Validate.validate(15, >=: 10) == success(15)
  end

  test "it compares numbers" do
    assert GreaterThan.validate(%{@input | value: 10, arg: 1}) == success(10)
    assert GreaterThan.validate(%{@input | value: 1.10, arg: 1}) == success(1.10)

    assert GreaterThan.validate(%{@input | value: 1, arg: 1}) == error("must be greater than 1")

    assert GreaterThan.validate(%{@input | value: 1, arg: 2}) ==
             error("must be greater than 2")
  end

  test "it compares dates" do
    date = Timex.parse!("2020-02-15", "{YYYY}-{0M}-{0D}") |> Timex.to_date()
    future_date = Date.add(date, 10)
    past_date = Date.add(date, -10)

    assert GreaterThan.validate(%{@input | value: future_date, arg: date}) ==
             success(future_date)

    assert GreaterThan.validate(%{@input | value: date, arg: date}) ==
             error("must be greater than 2020-02-15")

    assert GreaterThan.validate(%{@input | value: past_date, arg: date}) ==
             error("must be greater than 2020-02-15")
  end

  test "it compares datetimes" do
    date = Timex.parse!("2020-02-15T10:15:20Z", "{ISO:Extended}") |> Timex.to_datetime()
    future_date = DateTime.add(date, 15, :day)
    past_date = DateTime.add(date, -15, :day)

    assert GreaterThan.validate(%{@input | value: future_date, arg: date}) ==
             success(future_date)

    assert GreaterThan.validate(%{@input | value: date, arg: date}) ==
             error("must be greater than 2020-02-15 10:15:20Z")

    assert GreaterThan.validate(%{@input | value: past_date, arg: date}) ==
             error("must be greater than 2020-02-15 10:15:20Z")
  end

  test "it compares naive datetimes" do
    date = Timex.parse!("2020-02-15T10:15:20Z", "{ISO:Extended}") |> Timex.to_naive_datetime()
    future_date = NaiveDateTime.add(date, 15, :day)
    past_date = NaiveDateTime.add(date, -15, :day)

    assert GreaterThan.validate(%{@input | value: future_date, arg: date}) ==
             success(future_date)

    assert GreaterThan.validate(%{@input | value: date, arg: date}) ==
             error("must be greater than 2020-02-15 10:15:20")

    assert GreaterThan.validate(%{@input | value: past_date, arg: date}) ==
             error("must be greater than 2020-02-15 10:15:20")
  end
end
