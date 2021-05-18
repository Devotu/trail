defmodule TrailTest do
  use ExUnit.Case
  doctest Trail

  alias TestHelper

  @generic_state %{key: "value", list: ["a", "b"]}
  @generic_event %{id: "e0", input: "this came from somewhere else"}

  test "store and retrieve state x" do
    state_id = "state_one"
    assert {:ok} == Trail.store(state_id, @generic_state, @generic_event)
    assert @generic_state == Trail.recall(state_id)
    assert Trail.trace(state_id) |> is_list()
    TestHelper.wipe_test(state_id)
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

    TestHelper.wipe_test(state_id)
  end

  test "state existance" do
    state_id = "state_three"
    Trail.store(state_id, @generic_state, @generic_event)

    assert true == Trail.on_record?(state_id)
    assert true == Trail.has_state?(state_id)
    assert {:ok} == Trail.clear(state_id)
    assert true == Trail.on_record?(state_id)
    assert false == Trail.has_state?(state_id)

    TestHelper.wipe_test(state_id)
    assert false == Trail.on_record?(state_id)
  end

  @doc """
  Tests a very specific problem encountered while the delmiter was a double **
  Inherited from Metr
  """
  test "delimiter mixup" do
    state_id = "state_four"

    # Becomes <<131, 98, 95, 192, 31, 42>> when turned into binary
    # <<42>> is same as first of log delimiter and this should not be a problem
    specific_time = 1_606_426_410
    specific_event = %{id: "state_delimiter_mixup", time: specific_time}

    Trail.store(state_id, %{}, %{keys: [:correct], data: "first"})
    Trail.store(state_id, %{}, specific_event)
    Trail.store(state_id, %{}, %{keys: [:correct], data: "second"})
    Trail.store(state_id, %{}, %{keys: [:correct], data: "third"})

    entries = Trail.trace(state_id)
    assert 4 == Enum.count(entries)

    TestHelper.wipe_test(state_id)
    assert false == Trail.on_record?(state_id)
  end

  test "list current ids of type" do
    term = "Item"

    states = [term <> "_01", term <> "_02", "Thing" <> "_02", "third" <> term]
    [s1, s2, _s3, s4] = states

    states
    |> Enum.each(fn s -> Trail.store(s, @generic_state, @generic_event) end)

    listed_states = Trail.list_contains(term)

    assert 3 == Enum.count listed_states
    assert Enum.member?(listed_states, s1)
    assert Enum.member?(listed_states, s2)
    assert Enum.member?(listed_states, s4)

    TestHelper.wipe_test(states)
  end
end
