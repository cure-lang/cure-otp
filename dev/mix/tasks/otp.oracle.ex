defmodule Mix.Tasks.Otp.Oracle do
  use Mix.Task

  @shortdoc "Regenerate cure-otp's Cure/Idris oracle fixture"

  @impl Mix.Task
  def run(_argv) do
    Mix.Task.run("app.start")
    bin = Cure.Oracle.default_idris_bin()

    unless File.exists?(bin) do
      Mix.raise("idris2 not found at #{bin}; set IDRIS2_BIN to its executable")
    end

    prior = CureOtp.Oracle.read_fixture()

    fixture =
      CureOtp.Oracle.pairs()
      |> Task.async_stream(
        fn %{name: name, cure_path: cure_path, idr_path: idr_path} ->
          cure = Task.async(fn -> Cure.Oracle.cure_verdict_timed(cure_path) end)
          idris = Task.async(fn -> Cure.Oracle.idris_verdict_timed(bin, idr_path) end)
          {name, Task.await(cure, :infinity), Task.await(idris, :infinity)}
        end,
        max_concurrency: oracle_concurrency(),
        timeout: :infinity,
        ordered: false
      )
      |> Enum.map(fn {:ok, result} -> result end)
      |> Map.new(fn {name, {cure, cure_ms}, {idris, idris_ms}} ->
        previous = Map.get(prior, name, %{"relation" => "same", "reason" => ""})

        entry = %{
          "cure" => Atom.to_string(cure),
          "idris" => Atom.to_string(idris),
          "relation" => Map.get(previous, "relation", "same"),
          "reason" => Map.get(previous, "reason", "")
        }

        Mix.shell().info(
          "#{name}: cure=#{entry["cure"]} (#{cure_ms}ms) " <>
            "idris=#{entry["idris"]} (#{idris_ms}ms) rel=#{entry["relation"]}" <>
            if(Cure.Oracle.consistent(entry) == :ok, do: "", else: "  <-- TRIAGE")
        )

        {name, entry}
      end)

    CureOtp.Oracle.write_fixture(fixture)
    Mix.shell().info("wrote #{Path.join(CureOtp.Oracle.root(), "verdicts.json")}")
  end

  defp oracle_concurrency do
    case System.get_env("ORACLE_MAX_CONCURRENCY") do
      nil -> max(1, div(System.schedulers_online(), 2))
      value -> max(1, value |> String.trim() |> String.to_integer())
    end
  end
end
