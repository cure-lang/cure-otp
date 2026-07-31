ExUnit.start(timeout: 300_000)

Cure.Stdlib.Preload.preload(kind: :all)

{:ok, %{errors: []}} =
  Cure.Compiler.compile_files(Otp.Meta.TestSupport.source_paths(),
    source_roots: [Otp.Meta.TestSupport.source_root()],
    output_dir: "_build/metatheory/ebin",
    load_emitted: true
  )
