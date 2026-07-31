defmodule Cure.Otp.MetaThreePartyTest do
  @moduledoc """
  `Otp.Meta.ThreeParty` — three-role session projection. `bilateral_duality` proves a protocol
  bilateral between RA/RB projects those two to dual endpoints even with a third role present;
  `bystander_ab` proves the third role RC projects to LEnd (non-participation). Cross-checked
  against Idris (oracle `three_party`).
  """
  use ExUnit.Case, async: true

  test "the module is compiled into the stdlib preload" do
    assert Code.ensure_loaded?(:"Cure.Otp.Meta.ThreeParty")
  end

  test "bystander_ab: a non-participating role projects to the empty session" do
    # RA sends TA to RB, then RB sends TB to RA. RC is party to neither message, so its
    # projection is LEnd — it can be spawned or omitted freely.
    src = """
    mod TpBy
      use Otp.Meta.ThreeParty
      fn wf() -> Bilateral(GMsg(RA, RB, TA, GMsg(RB, RA, TB, GEnd()))) =
        BiAB(TA, BiBA(TB, BiEnd()))
      fn rc_empty() -> Equivalent(Local, project(GMsg(RA, RB, TA, GMsg(RB, RA, TB, GEnd())), RC), LEnd()) =
        bystander_ab(BiAB(TA, BiBA(TB, BiEnd())))
    end
    """

    assert {:ok, _} = Otp.Meta.TestSupport.elaborate(src)
  end

  test "bilateral_duality: RA and RB project to dual endpoints despite RC's presence" do
    src = """
    mod TpDual
      use Otp.Meta.ThreeParty
      fn coherent() -> Equivalent(Local, project(GMsg(RA, RB, TA, GEnd()), RA), dual(project(GMsg(RA, RB, TA, GEnd()), RB))) =
        bilateral_duality(BiAB(TA, BiEnd()))
    end
    """

    assert {:ok, _} = Otp.Meta.TestSupport.elaborate(src)
  end
end
