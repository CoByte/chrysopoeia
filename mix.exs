defmodule Chrysopoeia.MixProject do
  use Mix.Project

  def project do
    [
      app: :chrysopoeia,
      version: "0.1.1",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/CoByte/chrysopoeia"
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
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description() do
  end

  defp package() do
    [
      description: "A simple parser combinator library",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/CoByte/chrysopoeia"}
    ]
  end
end
