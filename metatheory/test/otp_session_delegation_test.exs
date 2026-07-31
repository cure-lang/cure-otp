defmodule Cure.Otp.MetaSessionDelegationTest do
  @moduledoc """
  `Otp.Meta.SessionDelegation` — higher-order channels (delegation). A channel of session type A can
  be sent over another channel; the delegated A is transferred as-is (not dualized). `dual_involution`
  and `compat_dual` still hold with channel passing. Cross-checked against Idris (oracle
  `session_delegation`).
  """
  use ExUnit.Case, async: true

  test "the module is compiled into the stdlib preload" do
    assert Code.ensure_loaded?(:"Cure.Otp.Meta.SessionDelegation")
  end

  test "compat_dual with delegation: delegating a channel is compatible with resuming the same channel" do
    # One endpoint delegates a channel of type SSend(TB, SEnd) then ends; the peer resumes a
    # channel of the SAME type then ends. compat_dual certifies they are dual.
    src = """
    mod SdInst
      use Otp.Meta.SessionDelegation
      fn c0() -> Compat(SDeleg(SSend(TB, SEnd()), SEnd()), SResume(SSend(TB, SEnd()), SEnd())) =
        CDel(SSend(TB, SEnd()), CEnd())
      fn dual_ok() -> Equivalent(SType, SDeleg(SSend(TB, SEnd()), SEnd()), dual(SResume(SSend(TB, SEnd()), SEnd()))) =
        compat_dual(CDel(SSend(TB, SEnd()), CEnd()))
    end
    """

    assert {:ok, _} = Otp.Meta.TestSupport.elaborate(src)
  end

  test "dual_involution holds for a delegating protocol (carried type unchanged)" do
    src = """
    mod SdInvol
      use Otp.Meta.SessionDelegation
      fn invol() -> Equivalent(SType, dual(dual(SDeleg(SRecv(TA, SEnd()), SSend(TC, SEnd())))), SDeleg(SRecv(TA, SEnd()), SSend(TC, SEnd()))) =
        dual_involution(SDeleg(SRecv(TA, SEnd()), SSend(TC, SEnd())))
    end
    """

    assert {:ok, _} = Otp.Meta.TestSupport.elaborate(src)
  end
end
