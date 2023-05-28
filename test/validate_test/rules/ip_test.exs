defmodule ValidateTest.Rules.IpTest do
  use ExUnit.Case
  doctest Validate.Rules.Ip

  import Validate.Validator

  @v4 "127.0.0.1"
  @v6 "3ffe:b80:1f8d:2:204:acff:fe17:bf38"

  @input %{
    value: "",
    input: "",
    arg: true
  }

  @error {:error, "not a valid ip address"}
  @error_v4 {:error, "not a valid ipv4 address"}
  @error_v6 {:error, "not a valid ipv6 address"}

  test "it can be called from validate" do
    assert Validate.validate("127.0.0.1", ip: true) == success("127.0.0.1")
  end

  describe "arg: true" do
    test "it returns success when value is a v4" do
      assert Validate.Rules.Ip.validate(%{@input | value: @v4}) == success(@v4)
    end

    test "it returns success when value is a v6" do
      assert Validate.Rules.Ip.validate(%{@input | value: @v6}) == success(@v6)
    end

    test "it returns error when value is not an ip" do
      assert Validate.Rules.Ip.validate(%{@input | value: "127.abcd.1"}) == @error
    end
  end

  describe "arg: v4" do
    test "it returns success when value is a v4" do
      assert Validate.Rules.Ip.validate(%{@input | arg: :v4, value: @v4}) == success(@v4)
    end

    test "it returns error when value is a v6" do
      assert Validate.Rules.Ip.validate(%{@input | arg: :v4, value: @v6}) == @error_v4
    end

    test "it returns error when value is not an ip" do
      assert Validate.Rules.Ip.validate(%{@input | arg: :v4, value: "127.abcd.1"}) == @error_v4
    end
  end

  describe "arg: v6" do
    test "it returns error when value is a v4" do
      assert Validate.Rules.Ip.validate(%{@input | arg: :v6, value: @v4}) == @error_v6
    end

    test "it returns success when value is a v6" do
      assert Validate.Rules.Ip.validate(%{@input | arg: :v6, value: @v6}) == success(@v6)
    end

    test "it returns error when value is not an ip" do
      assert Validate.Rules.Ip.validate(%{@input | arg: :v6, value: "127.abcd.1"}) == @error_v6
    end
  end

  test "it throws when arg is not valid" do
    assert_raise(RuntimeError, "false is not a valid option for the ip validator", fn ->
      Validate.Rules.Ip.validate(%{@input | arg: false})
    end)
  end
end
