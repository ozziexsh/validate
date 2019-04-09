defmodule Consent.MixProject do
  use Mix.Project

  def project do
    [
      app: :consent,
      name: "Consent",
      description: description(),
      package: package(),
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
    ]
  end

  defp description() do
    "Validate incoming requests in an easy to reason-about way"
  end

  defp package() do
    [
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/nehero/consent"}
    ]
  end
end
