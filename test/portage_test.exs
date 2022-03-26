defmodule PortageTest do
  use ExUnit.Case
  doctest Portage

  test "greets the world" do
    assert Portage.hello() == :world
  end
end
