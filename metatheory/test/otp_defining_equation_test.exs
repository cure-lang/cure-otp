defmodule Cure.Otp.MetaDefiningEquationTest do
  use ExUnit.Case, async: true

  alias Cure.Core.{Env, Kernel}
  alias Cure.Elab.Program

  test "large-elimination equations are exported as kernel-checked theorems" do
    path = Path.join(Otp.Meta.TestSupport.source_root(), "otp_call_result.cure")
    assert {:ok, checked} = Program.module_interface("Otp.Meta.CallResult", path)

    assert [vnat, vbool] = Env.equations(checked.export_env, :RepVal)
    assert Enum.map([vnat, vbool], & &1.pattern_key) == ["RepVal/VNat", "RepVal/VBool"]

    for equation <- [vnat, vbool] do
      assert %{type: type} = Env.get_def(checked.export_env, equation.theorem)
      assert inspect(type) =~ "TypeEquivalent"
      assert :ok = Kernel.check_def(checked.export_env, equation.theorem)
    end
  end
end
