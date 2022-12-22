defmodule Portage.WorkerSupervisor do
  @moduledoc false
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def start_worker(sleep_duration) do
    DynamicSupervisor.start_child(__MODULE__, {Portage.Worker, sleep_duration: sleep_duration})
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
