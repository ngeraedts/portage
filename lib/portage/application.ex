defmodule Portage.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Portage.WorkerSupervisor
    ]

    opts = [strategy: :one_for_one, name: Portage.Application]
    Supervisor.start_link(children, opts)
  end
end
