defmodule CureOtp.MixProject do
  use Mix.Project

  def project do
    [
      app: :cure_otp,
      version: "0.1.0",
      elixir: "~> 1.18",
      elixirc_paths: elixirc_paths(Mix.env()),
      test_paths: ["metatheory/test"],
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["dev", "test/support"]
  defp elixirc_paths(:dev), do: ["dev"]
  defp elixirc_paths(_), do: []

  defp deps do
    compiler_path = System.get_env("CURE_COMPILER_PATH") || "../cure-lang"

    [
      {:cure, path: compiler_path, only: [:dev, :test]}
    ]
  end
end
