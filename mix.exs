defmodule Validate.MixProject do
  use Mix.Project

  def project do
    [
      app: :validate,
      name: "Validate",
      description: description(),
      package: package(),
      version: "1.3.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:timex, "~> 3.0"}
    ]
  end

  defp description() do
    "Validate any data"
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ozziexsh/validate"}
    ]
  end
end
