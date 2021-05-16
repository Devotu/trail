defmodule Trail.Log do
  @delimiter "*___*_*_*"

  alias Trail.Store

  defp path(id) do
    Store.data_dir() <> "/event/#{id}.log"
  end

  def log(id, event) do
    path = path(id)
    bin = :erlang.term_to_binary(event)
    del = bin <> @delimiter
    File.write(path, del, [:append])
  end

  def read(id) do
    id
    |> path()
    |> Store.read_binary_from_path()
    |> Store.parse_delimited_binary(@delimiter)
  end

  def on_record?(id) do
    id
    |> path()
    |> File.exists?()
  end
end
