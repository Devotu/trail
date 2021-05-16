defmodule Trail.Store do
  def data_dir(), do: File.cwd!() <> "/data"
end
