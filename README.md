# Cure OTP

`cure-otp` is a small, standalone Cure package for typed Erlang/OTP process
operations. It contains only the executable algebra:

- `Otp.Raw` is the sealed foreign-function boundary over Erlang/OTP.
- `Otp.Beam` validates opaque native terms without crossing package identities.
- `Otp` is the typed surface for process handles, calls, messages, monitors,
  timers, names, selectors, actors, state machines, and supervisors.

The research metatheory, proof corpus, and differential oracle are deliberately
not part of this package.

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

The `integration/consumer` project is a real path-dependency smoke test. From
that directory:

```sh
cure deps
cure compile lib/main.cure
```

The package is licensed under Apache-2.0.
