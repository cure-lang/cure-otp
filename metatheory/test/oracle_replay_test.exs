defmodule CureOtp.OracleReplayTest do
  use ExUnit.Case, async: false

  test "every Cure oracle has an Idris pair and exactly one recorded verdict" do
    pairs = CureOtp.Oracle.pairs()
    fixture = CureOtp.Oracle.read_fixture()
    names = Enum.map(pairs, & &1.name)

    assert Enum.all?(pairs, &File.regular?(&1.idr_path))
    assert Enum.sort(Map.keys(fixture)) == names
  end

  @tag timeout: :infinity
  test "recorded Cure oracle verdicts still hold" do
    assert :ok = CureOtp.Oracle.replay()
  end
end
