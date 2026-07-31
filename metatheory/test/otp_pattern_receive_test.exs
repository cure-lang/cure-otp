defmodule Cure.Otp.MetaPatternReceiveTest do
  @moduledoc """
  `Otp.Meta.PatternReceive` — pattern-directed selective receive (a pattern = a set of acceptable
  tags, generalizing the single-tag scan). `selrecv_matches` proves the received message always
  matches the pattern; `selrecv_present` proves it was actually in the mailbox. Cross-checked
  against Idris (oracle `pattern_receive`).
  """
  use ExUnit.Case, async: true

  test "the module is compiled into the stdlib preload" do
    assert Code.ensure_loaded?(:"Cure.Otp.Meta.PatternReceive")
  end

  test "a pattern-directed receive skips a non-matching head and delivers a matching message" do
    # Pattern {TB}, mailbox [TA, TB]: skip TA (not in pattern), receive TB, residual [TA].
    # selrecv_matches certifies the delivered TB matches the pattern.
    src = """
    mod PrInst
      use Otp.Meta.PatternReceive
      fn sr() -> SelRecv(TCons(TB, TNil()), BCons(TA, BCons(TB, BNil())), TB, BCons(TA, BNil())) =
        SRSkip(SRHere(Here()))
      fn matched() -> InSet(TB, TCons(TB, TNil())) = selrecv_matches(sr())
    end
    """

    assert {:ok, _} = Otp.Meta.TestSupport.elaborate(src)
  end
end
