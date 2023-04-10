defmodule Validate.Plugs.FormRequest do
  defmacro __using__(opts) do
    validate_success = Keyword.get(opts, :validate_success)
    validate_error = Keyword.get(opts, :validate_error)
    auth_error = Keyword.get(opts, :auth_error)

    quote do
      def init(request), do: request

      def call(conn, request) do
        with {:auth, true} <- {:auth, maybe_authorize(conn, request)},
             {:validate, {:ok, data}} <-
               {:validate, Validate.validate(conn.params, request.rules(conn))} do
          if Kernel.function_exported?(request, :perform, 2) do
            apply(request, :perform, [conn, data])
          else
            apply(__MODULE__, unquote(validate_success), [conn, data])
          end
        else
          {:auth, false} ->
            apply(__MODULE__, unquote(auth_error), [conn])

          {:validate, {:error, errors}} ->
            apply(__MODULE__, unquote(validate_error), [conn, errors])
        end
      end

      defp maybe_authorize(conn, request) do
        authorize_exists? = Kernel.function_exported?(request, :authorize, 1)
        if authorize_exists?, do: !!request.authorize(conn), else: true
      end
    end
  end
end
