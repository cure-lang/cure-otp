# OTP metatheory

This directory contains the research corpus for Cure's OTP formalisation. It is
deliberately separate from the shipped standard library:

- `src/` contains executable models, relations, and machine-checked proofs.
- `test/` contains the corresponding ExUnit regression corpus.
- `oracle/otp/` is the frozen paired Cure/Idris verdict corpus.

The reusable process algebra is the standalone `cure-otp` package beside the
`cure-lang` repository. Its three source modules (`Otp.Raw`, `Otp.Beam`, and
`Otp`) do not import this metatheory corpus. The `Otp.Meta` modules remain the
stdlib compatibility surface for existing Cure programs.

Run the complete metatheory corpus with the ordinary test command:

```sh
mix test
```

`mix.exs` sets `metatheory/test` as the project's test path. Its test helper
compiles `metatheory/src` explicitly into `_build/metatheory/ebin`; those proof
modules are therefore checked by `mix test` without becoming part of the
published Cure package. `Cure.toml` exposes only `lib` to ordinary Cure builds.

## Oracle fixtures

Each `oracle/otp/<name>.cure` input is paired with the corresponding
`<name>.idr` input and a recorded relation in `oracle/otp/verdicts.json`. These
files preserve the exact programs used for the comparison, including older
accepted Cure syntax. They are test fixtures, not style examples or sources for
generated documentation.

Do not modernise only one side of a pair. Change an oracle only when the
comparison itself changes, update its Cure and Idris inputs together where
applicable, and re-record the verdict deliberately. `mix test` checks that every
Cure input has an Idris partner and exactly one recorded verdict, then replays
all Cure verdicts.
