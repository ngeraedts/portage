defmodule PortageTest do
  use ExUnit.Case
  doctest Portage

  test "run the python program" do
    assert {:ok, pid} = Portage.run(1)

    ref = Process.monitor(pid)

    assert_receive {:DOWN, ^ref, :process, _pid, :normal}, 1_250
  end
end
