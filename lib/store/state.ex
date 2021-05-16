defmodule Trail.State do
  alias Trail.Store

  defp path(id) do
    Store.data_dir() <> "/state/#{id}.state"
  end

  def store(id, state) do
    path = path(id)
    bin = :erlang.term_to_binary(state)
    File.write!(path, bin)
  end

  def retrieve(id) do
    id
    |> path()
    |> File.read!()
    |> :erlang.binary_to_term()
  end
end
