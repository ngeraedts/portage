defmodule Portage do
  @moduledoc """
  Documentation for `Portage`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Portage.hello()
      :world

  """
  def hello do
    :world
  end

  def run do
    Portage.Supervisor.start_worker()
  end
end
