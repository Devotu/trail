defmodule Trail.State do
  alias Trail.Store
  alias Trail.Helpers

  defp path(id) do
    Store.data_dir() <> "/state/#{id}.state"
  end

  def store(id, state) do
    path = path(id)
    bin = :erlang.term_to_binary(state)
    File.write(path, bin)
  end

  def retrieve(id) do
    id
    |> path()
    |> Store.read_binary_from_path()
    |> Store.parse_binary()
  end

  def has_state?(id) do
    id
    |> path()
    |> File.exists?()
  end

  def wipe(id) do
    id
    |> path()
    |> File.rm()
    |> Helpers.enforce_tuple()
  end
end
