defmodule Cure.Otp.MetaFiniteFixpointTest do
  @moduledoc """
  `Otp.Meta.FiniteFixpoint` — the finite Kleene least-fixed-point theorem (mathlib port) for a
  height-3 interface lattice: `lfp_le` (leastness), `monotone_iterate` (ascending chain), and
  `map_lfp_le` (`f(f⁴(⊥)) ⊑ f⁴(⊥)`, the fixed-point property BRec adequacy needs). Re-checked
  every build via the stdlib preload and cross-checked against Idris (oracle `finite_fixpoint`).
  These tests pin that the fixed-point theorem is USABLE at a concrete monotone transfer.
  """
  use ExUnit.Case, async: true

  test "the module is compiled into the stdlib preload" do
    assert Code.ensure_loaded?(:"Cure.Otp.Meta.FiniteFixpoint")
  end

  test "map_lfp_le instantiates at the identity transfer" do
    # f = id is monotone (Sub x y -> Sub (id x) (id y) is identity), so its fixed-point theorem
    # holds — a non-vacuous use of the shipped lemma via `use`.
    src = """
    mod FfInst
      use Otp.Meta.FiniteFixpoint
      fn idf(x: IF) -> IF = x
      fn idmono(x: IF, y: IF, s: Sub(x, y)) -> Sub(idf(x), idf(y)) = s
      fn fixed() -> Sub(idf(iter(idf, S(S(S(S(Z)))))), iter(idf, S(S(S(S(Z)))))) =
        map_lfp_le(idf, idmono)
    end
    """

    assert {:ok, _} = Otp.Meta.TestSupport.elaborate(src)
  end
end
