defmodule ValidateTest.Rules.LessThanEqualTest do
  use ExUnit.Case
  doctest Validate.Rules.LessThanEqual
  alias Validate.Rules.LessThanEqual

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: ""
  }

  test "it can be called from validate" do
    assert Validate.validate(5, <=: 10) == success(5)
  end

  test "it compares numbers" do
    assert LessThanEqual.validate(%{@input | value: 1, arg: 1}) == success(1)
    assert LessThanEqual.validate(%{@input | value: 1, arg: 10}) == success(1)
    assert LessThanEqual.validate(%{@input | value: 1, arg: 1.10}) == success(1)

    assert LessThanEqual.validate(%{@input | value: 2, arg: 1}) ==
             error("must be less than or equal to 1")
  end

  test "it compares dates" do
    date = Timex.parse!("2020-02-15", "{YYYY}-{0M}-{0D}") |> Timex.to_date()
    future_date = Date.add(date, 10)
    past_date = Date.add(date, -10)

    assert LessThanEqual.validate(%{@input | value: date, arg: date}) == success(date)

    assert LessThanEqual.validate(%{@input | value: past_date, arg: date}) ==
             success(past_date)

    assert LessThanEqual.validate(%{@input | value: future_date, arg: date}) ==
             error("must be less than or equal to 2020-02-15")
  end

  test "it compares datetimes" do
    date = Timex.parse!("2020-02-15T10:15:20Z", "{ISO:Extended}") |> Timex.to_datetime()
    future_date = DateTime.add(date, 15, :day)
    past_date = DateTime.add(date, -15, :day)

    assert LessThanEqual.validate(%{@input | value: date, arg: date}) == success(date)

    assert LessThanEqual.validate(%{@input | value: past_date, arg: date}) ==
             success(past_date)

    assert LessThanEqual.validate(%{@input | value: future_date, arg: date}) ==
             error("must be less than or equal to 2020-02-15 10:15:20Z")
  end

  test "it compares naive datetimes" do
    date = Timex.parse!("2020-02-15T10:15:20Z", "{ISO:Extended}") |> Timex.to_naive_datetime()
    future_date = NaiveDateTime.add(date, 15, :day)
    past_date = NaiveDateTime.add(date, -15, :day)

    assert LessThanEqual.validate(%{@input | value: date, arg: date}) == success(date)

    assert LessThanEqual.validate(%{@input | value: past_date, arg: date}) ==
             success(past_date)

    assert LessThanEqual.validate(%{@input | value: future_date, arg: date}) ==
             error("must be less than or equal to 2020-02-15 10:15:20")
  end
end
