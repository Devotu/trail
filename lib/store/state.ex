defmodule Trail.State do
  alias Trail.Store
  alias Trail.Helpers

  @postfix ".state"

  defp path(id) do
    Store.data_dir() <> "/state/#{id}#{@postfix}"
  end

  defp path() do
    Store.data_dir() <> "/state/"
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

  def list_contains(term) do
    path()
    |> File.ls!()
    |> Enum.map(fn file_path -> String.replace(file_path, path(), "") end)
    |> Enum.filter(fn name -> String.contains?(name, term) end)
    |> Enum.map(fn name -> String.replace(name, @postfix, "") end)
  end
end
