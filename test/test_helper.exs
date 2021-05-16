ExUnit.start()

defmodule TestHelper do
  alias Trail.Store

  def wipe_test(id) do
    Store.data_dir() <> "/state/#{id}.state"
    |> wipe_file()
    Store.data_dir() <> "/event/#{id}.log"
    |> wipe_file()
  end

  defp wipe_file(path) do
    if File.exists?(path) do
      File.rm!(path)
    end
  end
end
