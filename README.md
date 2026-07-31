# Cure OTP

`cure-otp` is a small, standalone Cure package for typed Erlang/OTP process
operations. It contains only the executable algebra:

- `Otp.Raw` is the sealed foreign-function boundary over Erlang/OTP.
- `Otp.Beam` validates opaque native terms without crossing package identities.
- `Otp` is the typed surface for process handles, calls, messages, monitors,
  timers, names, selectors, actors, state machines, and supervisors.

The executable package surface remains the three modules above. The repository
also owns its formal model and verification corpus:

- `metatheory/src` contains executable models, relations, and machine-checked
  proofs under the package-owned `Otp.Meta.*` namespace.
- `metatheory/test` contains the ExUnit regression suite.
- `metatheory/oracle` contains the paired Cure and Idris verdict corpus.

These are development inputs, not modules in Cure's shipped standard library.

## Use as a path dependency

```toml
[dependencies]
otp = { path = "../cure-otp" }
```

Then import the public module:

```cure
mod Example
  use Otp

  fn accepts_ping() -> Bool =
    handles(message_code(:ping, 0), :ping, 0)
```

From a Cure project, run `cure deps` before compiling the project.

## Development

Run the formal regression suite from this repository:

```sh
mix test
mix otp.oracle.replay
```

The replay command checks Cure against the committed differential verdicts
without requiring Idris. To regenerate those verdicts against Idris 2, run
`mix otp.oracle`; set `IDRIS2_BIN` when `idris2` is not in the default
development location.

The `integration/consumer` project is a real path-dependency smoke test. From
that directory:

```sh
cure deps
cure compile lib/main.cure
```

The package is licensed under Apache-2.0.
