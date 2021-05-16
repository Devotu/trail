defmodule TrailTest do
  use ExUnit.Case
  doctest Trail

  @generic_state %{key: "value", list: ["a", "b"]}
  @generic_event %{id: "e0", input: "this came from somewhere else"}

  test "store and retrieve state x" do
    state_id = "state_one"
    assert {:ok} == Trail.store(state_id, @generic_state, @generic_event)
    assert @generic_state == Trail.recall(state_id)
    assert Trail.trace(state_id) |> is_list()
  end

  test "store and retrieve long trail" do
    state_id = "state_two"

    final_state = Map.put(@generic_state, :key, "third")

    Trail.store(state_id, Map.put(@generic_state, :key, "first") , Map.put(@generic_event, :id, "e1"))
    Trail.store(state_id, Map.put(@generic_state, :key, "second") , Map.put(@generic_event, :id, "e2"))
    Trail.store(state_id, final_state, Map.put(@generic_event, :id, "e3"))

    assert final_state == Trail.recall(state_id)

    [e1, e2, e3] = Trail.trace(state_id) #also validating the count
    assert "e1" == e1.id
    assert "e2" == e2.id
    assert "e3" == e3.id
  end

end
