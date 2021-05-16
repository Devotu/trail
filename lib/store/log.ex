defmodule Trail.Log do
  @delimiter "*___*_*_*"

  alias Trail.Store

  defp event_path(id) do
    Store.data_dir() <> "/event/#{id}.log"
  end

  def log(id, event) do
    path = event_path(id)
    bin = :erlang.term_to_binary(event)
    del = bin <> @delimiter
    File.write!(path, del, [:append])
  end
end
