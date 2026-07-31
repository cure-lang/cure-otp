# Cure OTP proof checklist

## Proved

### Core process safety

- [x] Ether-to-mailbox reduction preserves accepted message tags
- [x] Well-typed configurations either finish or take a well-typed step
- [x] Multi-process interleavings preserve global well-typedness
- [x] Mailbox arrival and receive preserve FIFO order
- [x] Homogeneous and heterogeneous cross-process routing preserve well-typedness
- [x] Exhaustive mailboxes make maximal protocol progress

### Dependent messages and replies

- [x] Each request constructor determines its own reply type
- [x] Linear reply capabilities are consumed exactly once
- [x] Branching handlers preserve constructor-specific reply types
- [x] Delivery preserves dependent reply evidence
- [x] Complete runs conserve replies: none are lost or duplicated
- [x] Actor message types are derived from their handlers
- [x] Effectful spawn and send preserve the derived message type
- [x] Dependent calls return the reply type selected by the request
- [x] Dependent `handle_call` callbacks return request-specific replies
- [x] Call failure remains explicit and must be handled

### Monitors, links, signals, and timers

- [x] Monitor references carry evidence that `DOWN` is accepted
- [x] Removing a monitor makes later `DOWN` delivery unconstructible
- [x] Link references distinguish linked and unlinked states
- [x] Exit handling respects `trap_exit`
- [x] Normal, abnormal, and kill exits have distinct propagation rules
- [x] Exit propagation across a link chain terminates at the first trapper
- [x] Per-sender message, link, monitor, exit, and `DOWN` signals remain ordered
- [x] Death notifications are terminal within each sender stream
- [x] Cancelled timers cannot fire
- [x] Receive timeouts preserve lifecycle state

### Supervision

- [x] `one_for_one`, `one_for_all`, and `rest_for_one` preserve child specifications
- [x] `one_for_one` isolates unaffected siblings
- [x] Restart intensity prevents unbounded restart loops
- [x] Restart intensity has an exact failure bound
- [x] Exhausted child supervisors escalate to their parent
- [x] Permanent, transient, and temporary restart policies have the expected behavior
- [x] Dynamic uniform child pools preserve their specification and membership laws
- [x] Restarting an asynchronous session must flush in-flight messages
- [x] Supervised sessions either complete or exhaust their restart budget

### Mailbox inference

- [x] Handler membership and whole-interface coverage are decidable
- [x] Inference is monotone, weakening-safe, and principal
- [x] Sequential and branching inference are operationally adequate
- [x] Recursive behavior transfer functions are derived from syntax
- [x] Recursive transfer is monotone
- [x] Finite Kleene iteration stabilizes
- [x] The inferred recursive interface is the least fixed point
- [x] Recursive inference covers every direct send
- [x] Recursive inference is operationally adequate

### Counting mailbox types

- [x] Mailboxes are modeled by commutative regular expressions over multisets
- [x] Pattern multiplication is a commutative monoid
- [x] Pattern choice is a commutative monoid
- [x] Zero annihilates multiplication
- [x] Multiplication distributes over choice
- [x] Kleene star satisfies its unfold and fold laws
- [x] Nullability is sound and complete
- [x] Brzozowski derivatives are sound and complete
- [x] Derivative folding decides word acceptance
- [x] Syntactic inclusion implies semantic inclusion
- [x] Derivatives are monotone under inclusion
- [x] Accepted mailbox contents can always be drained to a satisfied empty state

### Binary sessions

- [x] Duality is involutive
- [x] Compatibility is equivalent to duality
- [x] Compatibility is symmetric and determines a unique peer
- [x] Communication steps preserve compatibility
- [x] Complete runs preserve compatibility
- [x] Compatible finite sessions make progress and terminate
- [x] Terminating runs have exactly the protocol depth in steps
- [x] Endpoint swapping reverses every step and run
- [x] Recursive duality commutes with substitution and unfolding
- [x] Session delegation preserves duality and compatibility
- [x] Session subtyping is reflexive, transitive, antisymmetric, and dual-antitone
- [x] Session subtyping supports safe substitution
- [x] Dependent OTP calls have compatible client and server sessions

### Sessions encoded as mailboxes

- [x] An endpoint's receives equal its dual peer's sends
- [x] Compatible endpoints have balanced send and receive multisets
- [x] Parallel session composition preserves encoding fidelity
- [x] Sequential session composition maps to multiset addition
- [x] Session-to-mailbox encoding is a monoid homomorphism
- [x] Mailbox equivalence is compositional under sequential and parallel composition
- [x] The encoding intentionally forgets protocol order while preserving message counts

### Multiparty sessions

- [x] Global protocols project to coherent local endpoints
- [x] Projection preserves duality for the active participants
- [x] Global progress and subject reduction hold
- [x] Every global step has matching local steps
- [x] Whole projected configurations follow complete global runs
- [x] Bystanders are unchanged by unrelated communications
- [x] Branch merge makes bystander projection defined
- [x] Branch merge is the greatest lower bound under session subtyping
- [x] Branch intersection is the least upper bound
- [x] Branch subtyping forms a distributive lattice
- [x] Projection is total for every role in well-formed three-role protocols
- [x] Per-role subtype implementations preserve protocol progress
- [x] Recursive projection commutes with unfolding
- [x] Branch merge commutes with recursive substitution
- [x] Recursive choice projection commutes with unfolding
- [x] Guarded recursive protocols unfold to productive actions
- [x] N-ary choice duality and active-role projection coherence hold

### OTP behaviors and state machines

- [x] Callback lifecycles cannot reinitialize or resurrect a terminated server
- [x] Event postponement and redelivery conserve unprocessed events
- [x] Handled-event counts compose across runs
- [x] Gen-statem invariants hold in every reachable state
- [x] Concrete state machines forward-simulate their abstract specifications
- [x] Safety properties transfer through refinement
- [x] Bounded retries terminate by a decreasing measure
- [x] Concurrent mutual exclusion is invariant under interleaving
- [x] The concurrent mutex protocol is deadlock-free
- [x] Fair schedules provide liveness, while unfair schedules can starve
- [x] Mutual exclusion scales to an arbitrary number of processes
- [x] Effect sequencing forms a monoid
- [x] Effect handlers are monoid homomorphisms

### Data structures and distributed systems

- [x] Finite sets, bags, queues, priority queues, trees, and search trees satisfy their stated laws
- [x] ETS-style lookup, insert, and delete satisfy their finite-key laws
- [x] Sorting produces the unique sorted permutation
- [x] Run-length encoding round-trips
- [x] Euclidean division returns a quotient and bounded remainder satisfying the division equation
- [x] Graph reachability is transitive and equivalent to existence of a finite walk
- [x] Vector-clock order is a partial order
- [x] Vector-clock merge is a join-semilattice
- [x] Strict vector-clock precedence is a strict partial order
- [x] Fidge-Mattern soundness holds
- [x] Fidge-Mattern completeness holds for retrospective event clocks

## Left to prove or build

### Mailbox inference and conformance

- [ ] Generate bidirectional mailbox constraints from behaviors
- [ ] Implement Presburger/semilinear solving for Parikh constraints outside the trusted kernel
- [ ] Prove the full process-calculus form of de'Liguoro-Padovani reliability and usability
- [ ] Infer protocols whose accepted mailbox type evolves during a conversation

### Sessions and multiparty protocols

- [ ] Complete n-ary bystander merge, subtyping, and operational correspondence
- [ ] Add per-participant asynchronous semantics with peer-annotated local types and in-flight buffers

### OTP fidelity

- [ ] Model full exit-reason payloads
- [ ] Correlate `DOWN` messages with their exact monitor references
- [ ] Generalize cascading exit propagation from chains to arbitrary link graphs
- [ ] Model supervision's `max_seconds` time window
- [ ] Thread request and reply typing through the complete callback lifecycle
- [ ] Add `code_change` version transitions
- [ ] Model the complete state-function callback protocol for `gen_statem`
- [ ] Add a value-returning free-monad bind and composition of multiple effect handlers

### Compiler support needed by the formalisation

- [ ] Finish sibling-context refinement ergonomics for dependent matches
- [ ] Finish cross-module resolution for functions carrying implicit arguments
- [ ] Add code generation for explicit-argument partial application
- [ ] Promote dependent `call_dep` to the runnable package API without weakening kernel uniformity

### Explicitly outside the proof goal

- [ ] Treat unrestricted static deadlock and liveness checking as a runtime analysis problem rather than a decidable type-system theorem
