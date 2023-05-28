defmodule ValidateTest.Rules.UrlTest do
  alias Validate.Rules.Url
  use ExUnit.Case
  doctest Validate.Rules.Url

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: true
  }

  test "it can be called from validate" do
    assert Validate.validate("http://example.com", url: true) == success("http://example.com")
  end

  test "valid url with scheme returns success" do
    assert Url.validate(%{@input | value: "http://example.com"}) == success("http://example.com")

    assert Url.validate(%{@input | value: "http://example.com:4000"}) ==
             success("http://example.com:4000")

    assert Url.validate(%{@input | value: "https://example.com:4000/foo/bar?q=1"}) ==
             success("https://example.com:4000/foo/bar?q=1")

    assert Url.validate(%{@input | value: "https://localhost"}) == success("https://localhost")
  end

  test "valid url without scheme returns error" do
    assert Url.validate(%{@input | value: "example.com"}) == {:error, "must contain scheme"}
  end

  test "non-urls return error" do
    assert Url.validate(%{@input | value: "something.com asdjkasjk"}) ==
             {:error, "not a valid url"}
  end
end
