defmodule Portage do
  @moduledoc """
  Documentation for `Portage`.
  """

  @doc """
  Run a python worker.
  """
  def run(sleep_duration) do
    Portage.WorkerSupervisor.start_worker(sleep_duration)
  end
end
