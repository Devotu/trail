defmodule Trail do
  @moduledoc """
  Stores a state together with its building events
  """

  alias Trail.State
  alias Trail.Log

  @doc """
  Stores with log
  Currently lacking all types of atomic scope
  """
  def store(id, state, event) when is_bitstring(id) do
    logging = Log.log(id, event)
    storage = State.store(id, state)

    case [logging, storage] do
      [{:error, e}, _] -> {:error, e}
      [_, {:error, e}] -> {:error, e}
      _ -> {:ok}
    end
  end

  def recall(id) when is_bitstring(id) do

  end

  def track(id) when is_bitstring(id) do

  end
end
