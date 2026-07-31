defmodule Cure.Otp.MetaRecursiveTransferTest do
  @moduledoc """
  `Otp.Meta.RecursiveTransfer` — the syntax-derived interface transfer for recursive
  behaviours (`infer(BRec)`). Pins that the transfer is monotone for every body (`tset_mono`,
  the hypothesis the finite fixpoint theorem needs) and that `rec_fixed` reads off the
  fixed-point property (`f(infer) sub infer`) at a concrete recursive body via `map_lfp_le`.
  Cross-checked against Idris (oracle `recursive_transfer`); re-checked every build via the
  stdlib preload.
  """
  use ExUnit.Case, async: true

  test "the module is compiled into the stdlib preload" do
    assert Code.ensure_loaded?(:"Cure.Otp.Meta.RecursiveTransfer")
  end

  test "rec_fixed yields the fixed-point property for a concrete recursive body" do
    # mu X. send TA; recv TB; X  — a recursive loop whose inferred interface is {TA, TB}.
    # rec_fixed proves applying the derived transfer to that interface stays within it.
    src = """
    mod RtInst
      use Otp.Meta.FiniteFixpoint
      use Otp.Meta.RecursiveTransfer
      use Otp.Meta.InterfaceBridge
      fn loop_body() -> RBody = RSend(TA, RRecv(TB, RVar()))
      fn ex() -> Sub(tset(loop_body(), rec_infer(loop_body())), rec_infer(loop_body())) =
        rec_fixed(loop_body())
    end
    """

    assert {:ok, _} = Otp.Meta.TestSupport.elaborate(src)
  end

  test "rec_is_least: the inferred interface is below any pre-fixed point (principality)" do
    # {TA, TB} is a pre-fixed point of the transfer for mu X. send TA; recv TB; X
    # (applying the transfer to it gives itself), so the inferred interface is contained in
    # it — inference does not over-approximate.
    src = """
    mod RlInst
      use Otp.Meta.FiniteFixpoint
      use Otp.Meta.RecursiveTransfer
      use Otp.Meta.InterfaceBridge
      fn loop_body() -> RBody = RSend(TA, RRecv(TB, RVar()))
      fn least() -> Sub(rec_infer(loop_body()), MkIF(T, T, F)) =
        rec_is_least(loop_body(), MkIF(T, T, F), sub_refl(MkIF(T, T, F)))
    end
    """

    assert {:ok, _} = Otp.Meta.TestSupport.elaborate(src)
  end
end
