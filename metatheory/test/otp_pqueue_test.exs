defmodule Cure.Otp.MetaPQueueTest do
  @moduledoc """
  `Otp.Meta.PQueue` — a min priority queue over the certified key order (`Otp.Meta.KeyOrder`). The
  correctness theorem is that the extracted `pq_min` is a genuine LOWER BOUND of the queue: it is
  `<=` the seed (`min_le_seed`, via `le_trans` and `kmin_lower`) and `<=` the head element
  (`insert_min`, via `kmin_lower_l`). This is the first structure whose safety proof CONSUMES the
  order/semilattice axioms. Cross-checked against Idris (oracle `pqueue`).
  """
  use ExUnit.Case, async: true

  test "the module is compiled into the stdlib preload" do
    assert Code.ensure_loaded?(:"Cure.Otp.Meta.PQueue")
  end

  test "the extracted minimum is a lower bound of the queue (<= seed and <= head)" do
    src = """
    mod PQLaw
      use Otp.Meta.KeyOrder
      use Otp.Meta.PQueue
      fn le_seed(seed: OKey, q: PQ) -> Equivalent(OBit, le(pq_min(seed, q), seed), OT()) =
        min_le_seed(seed, q)
      fn le_head(k: OKey, seed: OKey, q: PQ) -> Equivalent(OBit, le(pq_min(seed, insert(k, q)), k), OT()) =
        insert_min(k, seed, q)
    end
    """

    assert {:ok, _} = Otp.Meta.TestSupport.elaborate(src)
  end
end
