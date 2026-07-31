defmodule Otp.Meta.TestSupport do
  @moduledoc false

  alias Cure.Compiler.ModuleIndex
  alias Cure.Elab.Program

  @source_root Path.expand("../../metatheory/src", __DIR__)
  @source_paths Path.wildcard(Path.join(@source_root, "*.cure"))
  @stdlib_root Cure.Stdlib.Paths.source_dir()
  @stdlib_paths Path.wildcard(Path.join(@stdlib_root, "*.cure"))

  def source_root, do: @source_root
  def source_paths, do: @source_paths

  def module_index do
    case :persistent_term.get({__MODULE__, :module_index}, nil) do
      %ModuleIndex{} = index ->
        index

      nil ->
        {:ok, index} = ModuleIndex.build(@stdlib_paths ++ @source_paths)
        :persistent_term.put({__MODULE__, :module_index}, index)
        index
    end
  end

  def elaborate(source, opts \\ []) do
    previous_roots = Process.get(:cure_source_roots)
    previous_index = Process.get(:cure_module_index)
    Process.put(:cure_source_roots, [@source_root, @stdlib_root])
    Process.put(:cure_module_index, module_index())

    try do
      Program.elaborate(source, opts)
    after
      restore(:cure_source_roots, previous_roots)
      restore(:cure_module_index, previous_index)
    end
  end

  defp restore(key, nil), do: Process.delete(key)
  defp restore(key, value), do: Process.put(key, value)
end
