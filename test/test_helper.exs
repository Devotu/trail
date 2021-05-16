ExUnit.start()

defmodule TestHelper do
  alias Trail.Store

  def wipe_test(id) do
    Store.data_dir() <> "/state/#{id}.state"
    |> File.rm!()
    Store.data_dir() <> "/event/#{id}.log"
    |> File.rm!()
  end
end
