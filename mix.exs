defmodule ElixirDbf.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_dbf,
      version: "0.1.10",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      description: "Small library for DBF parsing written in pure elixir",
      deps: deps(),
      package: package(),
      source_url: "https://github.com/nikneroz/elixir_dbf"
    ]
  end

  defp package do
    [
      description: "DBF parsing library for Elixir",
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/nikneroz/elixir_dbf"
      }
    ]
  end

  def application do
    [
      extra_applications: [:logger, :timex]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:timex, "~> 3.7.5"},
      {:exconv, "~> 0.1.3"}
    ]
  end
end
