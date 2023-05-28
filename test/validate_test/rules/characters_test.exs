defmodule ValidateTest.Rules.CharactersTest do
  use ExUnit.Case
  doctest Validate.Rules.Characters
  alias Validate.Rules.Characters

  import Validate.Validator

  @input %{
    value: "",
    input: "",
    arg: :alpha
  }

  @error {:error, "must only contain letters"}
  @error_dash {:error, "must only contain letters, numbers, dashes, and underscores"}
  @error_num {:error, "must only contain letters and numbers"}

  describe "arg: alpha" do
    test "it returns success when only letters" do
      assert Characters.validate(%{@input | value: "ABcd"}) == success("ABcd")
    end

    test "it returns error when more than letters" do
      assert Characters.validate(%{@input | value: "ABcd12"}) == @error
    end

    test "it returns success with non-ascii letters" do
      assert Characters.validate(%{@input | value: "ABcdç"}) == success("ABcdç")
    end
  end

  describe "arg: alpha_ascii" do
    test "it returns success when only letters" do
      assert Characters.validate(%{@input | arg: :alpha_ascii, value: "ABcd"}) ==
               success("ABcd")
    end

    test "it returns error when more than letters" do
      assert Characters.validate(%{@input | arg: :alpha_ascii, value: "ABcd12"}) ==
               @error
    end

    test "it returns error with non-ascii letters" do
      assert Characters.validate(%{@input | arg: :alpha_ascii, value: "ABcdç"}) ==
               @error
    end
  end

  describe "arg: alpha_dash" do
    test "it returns success when only letters, numbers, dash, underscore" do
      assert Characters.validate(%{@input | arg: :alpha_dash, value: "ABcd123_-"}) ==
               success("ABcd123_-")
    end

    test "it returns error when other symbols or spaces present" do
      assert Characters.validate(%{@input | arg: :alpha_dash, value: "ABcd12 askd"}) ==
               @error_dash
    end

    test "it returns success with non-ascii letters" do
      assert Characters.validate(%{@input | arg: :alpha_dash, value: "ABcd_-ç"}) ==
               success("ABcd_-ç")
    end
  end

  describe "arg: alpha_dash_ascii" do
    test "it returns success when only letters, numbers, dash, underscore" do
      assert Characters.validate(%{@input | arg: :alpha_dash_ascii, value: "ABcd123_-"}) ==
               success("ABcd123_-")
    end

    test "it returns error when other symbols or spaces present" do
      assert Characters.validate(%{@input | arg: :alpha_dash_ascii, value: "ABcd12 askd"}) ==
               @error_dash
    end

    test "it returns error with non-ascii letters" do
      assert Characters.validate(%{@input | arg: :alpha_dash_ascii, value: "ABcd_-ç"}) ==
               @error_dash
    end
  end

  describe "arg: alpha_num" do
    test "it returns success when only letters, numbers" do
      assert Characters.validate(%{@input | arg: :alpha_num, value: "ABcd123"}) ==
               success("ABcd123")
    end

    test "it returns error when other symbols or spaces present" do
      assert Characters.validate(%{@input | arg: :alpha_num, value: "ABcd12_ "}) ==
               @error_num
    end

    test "it returns success with non-ascii letters" do
      assert Characters.validate(%{@input | arg: :alpha_num, value: "ABcd123ç"}) ==
               success("ABcd123ç")
    end
  end

  describe "arg: alpha_num_ascii" do
    test "it returns success when only letters, numbers" do
      assert Characters.validate(%{@input | arg: :alpha_num_ascii, value: "ABcd123"}) ==
               success("ABcd123")
    end

    test "it returns error when other symbols or spaces present" do
      assert Characters.validate(%{@input | arg: :alpha_num_ascii, value: "ABcd12_ "}) ==
               @error_num
    end

    test "it returns success with non-ascii letters" do
      assert Characters.validate(%{@input | arg: :alpha_num_ascii, value: "ABcd123ç"}) ==
               @error_num
    end
  end
end
