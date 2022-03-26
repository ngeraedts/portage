defmodule Portage.Worker do
  use GenServer, restart: :temporary

  require Logger

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_args) do
    {:ok, nil, {:continue, :startup}}
  end

  def handle_continue(:startup, nil) do
    pythonpath = :code.priv_dir(:portage)
    cmd = "python -c \"from pyportage import hello; hello()\""
    env = [{'PYTHONPATH', to_charlist(pythonpath)}]

    port =
      Port.open({:spawn, cmd}, [
        {:env, env},
        :stderr_to_stdout,
        :line,
        :exit_status,
        :use_stdio
      ])

    {:noreply, port}
  end

  def handle_info({port, {:exit_status, status}}, port) do
    Logger.info("port #{inspect(port)} closed with status #{inspect(status)}")
    {:stop, :normal, nil}
  end

  def handle_info({port, {:data, {:eol, msg}}}, port) do
    Logger.info("got msg from python: #{inspect(msg)}")
    {:noreply, port}
  end

  def handle_info(msg, port) do
    Logger.info("got unexpected msg: #{inspect(msg)}")
    {:noreply, port}
  end
end
