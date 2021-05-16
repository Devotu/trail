defmodule TrailTest do
  use ExUnit.Case
  doctest Trail

  test "store and retrieve state x" do
    state = %{key: "value", list: ["a", "b"]}
    state_id = "state_one"
    event = %{id: "t1", input: "this came from somewhere else"}
    assert {:ok, state_id} == Trail.store(state_id, state, event)
    assert state = Trail.recall(state_id)
    assert Trail.track(state_id) |> is_list()
  end
end
