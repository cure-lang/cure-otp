defmodule Cure.Otp.MetaBstTest do
  @moduledoc """
  `Otp.Meta.Bst` — the ordered binary search tree behind Erlang gb_trees/gb_sets. `insert_member`
  proves the defining search-tree law: after inserting a key, a subsequent search for it succeeds
  (`member(k, insert(k, t)) = T`), because `member` and `insert` steer by the same comparison at
  every node. Keys are a finite ordered domain so `kcmp` reduces at proof time. Cross-checked
  against Idris (oracle `bst`).
  """
  use ExUnit.Case, async: true

  test "the module is compiled into the stdlib preload" do
    assert Code.ensure_loaded?(:"Cure.Otp.Meta.Bst")
  end

  test "a search-tree insert makes the key findable" do
    src = """
    mod BstLaw
      use Otp.Meta.Bst
      fn law(k: Key, t: Tree) -> Equivalent(B, member(k, insert(k, t)), T()) =
        insert_member(k, t)
      fn empty(k: Key) -> Equivalent(B, member(k, Leaf()), F()) =
        member_leaf(k)
      fn inst() -> Equivalent(B, member(KB(), insert(KB(), Node(Leaf(), KA(), Node(Leaf(), KC(), Leaf())))), T()) =
        insert_member(KB(), Node(Leaf(), KA(), Node(Leaf(), KC(), Leaf())))
      fn preserves(x: Key, k: Key, t: Tree, e: Equivalent(B, member(x, t), T())) -> Equivalent(B, member(x, insert(k, t)), T()) =
        insert_preserves(x, k, t, e)
      fn spec(x: Key, k: Key, t: Tree) -> Equivalent(B, member(x, insert(k, t)), orb(keq(x, k), member(x, t))) =
        insert_spec(x, k, t)
      fn comm(x: Key, j: Key, k: Key, t: Tree) -> Equivalent(B, member(x, insert(j, insert(k, t))), member(x, insert(k, insert(j, t)))) =
        insert_comm(x, j, k, t)
    end
    """

    assert {:ok, _} = Otp.Meta.TestSupport.elaborate(src)
  end
end
