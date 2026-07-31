defmodule Mix.Tasks.Otp.Oracle.Replay do
  use Mix.Task

  @shortdoc "Replay cure-otp's committed oracle fixture without Idris"

  @impl Mix.Task
  def run(_argv) do
    Mix.Task.run("app.start")

    case CureOtp.Oracle.replay() do
      :ok ->
        Mix.shell().info("#{length(CureOtp.Oracle.pairs())} oracle verdicts replayed")

      {:error, errors} ->
        Enum.each(errors, &Mix.shell().error(inspect(&1)))
        Mix.raise("#{length(errors)} oracle verdicts failed")
    end
  end
end
