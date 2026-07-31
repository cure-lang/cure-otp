defmodule CureOtp.Oracle do
  @moduledoc false

  @root Path.expand("../../metatheory/oracle/otp", __DIR__)

  def root, do: @root

  def pairs do
    @root
    |> Path.join("*.cure")
    |> Path.wildcard()
    |> Enum.sort()
    |> Enum.map(fn cure_path ->
      name = Path.basename(cure_path, ".cure")
      %{name: name, cure_path: cure_path, idr_path: Path.join(@root, name <> ".idr")}
    end)
  end

  def read_fixture do
    @root
    |> Path.join("verdicts.json")
    |> File.read!()
    |> JSON.decode!()
  end

  def write_fixture(fixture) do
    File.write!(Path.join(@root, "verdicts.json"), JSON.encode!(fixture) <> "\n")
  end

  def replay do
    fixture = read_fixture()

    pairs()
    |> Task.async_stream(
      fn %{name: name, cure_path: path} ->
        entry = Map.fetch!(fixture, name)
        actual = Cure.Oracle.cure_verdict(path) |> Atom.to_string()

        cond do
          actual != entry["cure"] -> {:error, {name, :cure_verdict_drift, entry["cure"], actual}}
          Cure.Oracle.consistent(entry) != :ok -> {:error, {name, :relation_violated, entry}}
          true -> :ok
        end
      end,
      max_concurrency: max(1, div(System.schedulers_online(), 2)),
      timeout: :infinity
    )
    |> Enum.flat_map(fn
      {:ok, :ok} -> []
      {:ok, {:error, reason}} -> [reason]
      {:exit, reason} -> [{:oracle_task_exit, reason}]
    end)
    |> case do
      [] -> :ok
      errors -> {:error, errors}
    end
  end
end
