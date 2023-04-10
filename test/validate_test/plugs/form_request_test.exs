defmodule ValidateTest.Plugs.FormRequestTest do
  use ExUnit.Case
  doctest Validate.Plugs.FormRequest

  @valid_input %{"name" => "joe"}
  @invalid_input %{"name" => ""}

  defmodule TestMod do
    use Validate.Plugs.FormRequest,
      validate_success: :validate_success,
      validate_error: :validate_error,
      auth_error: :auth_error

    def validate_success(_conn, data) do
      data
    end

    def validate_error(_, _), do: "validate err"
    def auth_error(_), do: "auth err"
  end

  defmodule TestReq do
    def rules(_), do: %{"name" => [required: true]}
  end

  test "it creates the needed plug functions" do
    assert Kernel.function_exported?(TestMod, :init, 1) == true
    assert Kernel.function_exported?(TestMod, :call, 2) == true
  end

  test "it doesnt need an authorize function" do
    assert TestMod.call(%{params: @valid_input}, TestReq) == @valid_input
  end

  test "it calls validation if authorization returns truthy value" do
    defmodule TruthyReq do
      def authorize(_), do: 1
      def rules(_), do: %{"name" => [required: true]}
    end

    assert TestMod.call(%{params: @valid_input}, TruthyReq) == @valid_input
  end

  test "it does not call validation if authorization returns falsy value" do
    defmodule FalsyReq do
      def authorize(_), do: nil
      def rules(_), do: %{"name" => [required: true]}
    end

    assert TestMod.call(%{params: @valid_input}, FalsyReq) == "auth err"
  end

  test "it calls validation err if validation fails" do
    assert TestMod.call(%{params: @invalid_input}, TestReq) == "validate err"
  end

  test "it calls perform if present on request" do
    defmodule PerfReq do
      def rules(_), do: %{"name" => [required: true]}
      def perform(_, data), do: {"perform", data}
    end

    assert TestMod.call(%{params: @valid_input}, PerfReq) == {"perform", @valid_input}
  end
end
