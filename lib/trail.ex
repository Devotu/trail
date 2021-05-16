defmodule Trail do
  @moduledoc """
  Stores a state together with its building events
  requries a base directory "data" in current working directory
  with two sub directories "state" and "event"
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

  @doc """
  Returns the current state of 'id'
  """
  def recall(id) when is_bitstring(id) do
    State.retrieve(id)
  end

  @doc """
  Returns all the events leading up to the current state of 'id'
  """
  def trace(id) when is_bitstring(id) do
    Log.read(id)
  end
end
