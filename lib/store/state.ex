defmodule Trail.State do
  alias Trail.Store

  defp state_path(id) do
    Store.data_dir() <> "/state/#{id}.state"
  end

  def store(id, state) do
    path = state_path(id)
    bin = :erlang.term_to_binary(state)
    File.write!(path, bin)
  end
end
