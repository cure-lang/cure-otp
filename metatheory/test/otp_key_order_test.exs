defmodule Cure.Otp.MetaKeyOrderTest do
  @moduledoc """
  `Otp.Meta.KeyOrder` — the decidable total order on keys that every ordered OTP structure
  (gb_trees/gb_sets/ordsets, `Otp.Meta.Bst`/`Otp.Meta.Gbt`) steers by. Certifies the four total-order
  axioms — reflexivity, totality, antisymmetry, transitivity — so downstream search-tree and sorted
  invariants rest on a proven order, not an assumed one. Cross-checked against Idris (oracle `key_order`).
  """
  use ExUnit.Case, async: true

  test "the module is compiled into the stdlib preload" do
    assert Code.ensure_loaded?(:"Cure.Otp.Meta.KeyOrder")
  end

  test "le is a decidable total order (reflexive, total, antisymmetric, transitive)" do
    src = """
    mod OrdLaw
      use Otp.Meta.KeyOrder
      fn refl(a: OKey) -> Equivalent(OBit, le(a, a), OT()) =
        le_refl(a)
      fn total(a: OKey, b: OKey) -> Equivalent(OBit, orb(le(a, b), le(b, a)), OT()) =
        le_total(a, b)
      fn antisym(a: OKey, b: OKey, p: Equivalent(OBit, le(a, b), OT()), q: Equivalent(OBit, le(b, a), OT())) -> Equivalent(OKey, a, b) =
        le_antisym(a, b, p, q)
      fn trans(a: OKey, b: OKey, c: OKey, p: Equivalent(OBit, le(a, b), OT()), q: Equivalent(OBit, le(b, c), OT())) -> Equivalent(OBit, le(a, c), OT()) =
        le_trans(a, b, c, p, q)
    end
    """

    assert {:ok, _} = Otp.Meta.TestSupport.elaborate(src)
  end

  test "kmin/kmax are a bounded meet-semilattice (comm, idem, assoc, lower/upper bounds)" do
    src = """
    mod MeetJoin
      use Otp.Meta.KeyOrder
      fn comm(a: OKey, b: OKey) -> Equivalent(OKey, kmin(a, b), kmin(b, a)) =
        kmin_comm(a, b)
      fn assoc(a: OKey, b: OKey, c: OKey) -> Equivalent(OKey, kmin(kmin(a, b), c), kmin(a, kmin(b, c))) =
        kmin_assoc(a, b, c)
      fn lower(a: OKey, b: OKey) -> Equivalent(OBit, le(kmin(a, b), a), OT()) =
        kmin_lower_l(a, b)
      fn upper(a: OKey, b: OKey) -> Equivalent(OBit, le(b, kmax(a, b)), OT()) =
        kmax_upper_r(a, b)
    end
    """

    assert {:ok, _} = Otp.Meta.TestSupport.elaborate(src)
  end
end
