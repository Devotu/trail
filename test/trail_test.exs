defmodule TrailTest do
  use ExUnit.Case
  doctest Trail

  test "greets the world" do
    assert Trail.hello() == :world
  end
end
