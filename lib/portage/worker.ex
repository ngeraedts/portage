defmodule Portage.Worker do
  @moduledoc """
  A GenServer worker to wrap a python application using Ports.
  """
  use GenServer, restart: :temporary

  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  @impl GenServer
  def init(args) do
    state = %{sleep_duration: args[:sleep_duration], port: nil}
    {:ok, state, {:continue, :startup}}
  end

  @impl GenServer
  def handle_continue(:startup, %{sleep_duration: sleep_duration} = state) do
    pythonpath = :code.priv_dir(:portage)
    cmd = "python -c \"from pyportage import hello; hello()\""

    env = [
      {'PYTHONPATH', to_charlist(pythonpath)},
      {'SLEEP_DURATION', to_charlist(sleep_duration)}
    ]

    port =
      Port.open({:spawn, cmd}, [
        {:env, env},
        :stderr_to_stdout,
        :line,
        :exit_status,
        :use_stdio
      ])

    {:noreply, %{state | port: port}}
  rescue
    _ ->
      {:stop, :error, nil}
  end

  @impl GenServer
  def handle_info(msg, state)

  def handle_info({port, {:exit_status, status}}, %{port: port}) do
    Logger.info("port #{inspect(port)} closed with status #{inspect(status)}")
    {:stop, :normal, nil}
  end

  def handle_info({port, {:data, {:eol, msg}}}, %{port: port} = state) do
    Logger.info("got msg from python: #{inspect(msg)}")
    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.info("got unexpected msg: #{inspect(msg)}")
    {:noreply, state}
  end
end
