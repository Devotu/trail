defmodule Trail.Store do
  def data_dir(), do: File.cwd!() <> "/data"

  def read_binary_from_path(path) do
    case File.read(path) do
      {:ok, binary} ->
        binary

      {:error, :enoent} ->
        {:error, "not found"}

      {:error, cause} ->
        {:error, cause}
    end
  end

  def parse_binary({:error, e}), do: {:error, e}
  def parse_binary(binary) do
    binary
    |> :erlang.binary_to_term()
  end

  def parse_delimited_binary({:error, e}, _delimiter), do: {:error, e}
  def parse_delimited_binary(binary, delimiter) do
    binary
    |> String.slice(0..-String.length(delimiter))
    |> String.split(delimiter)
    |> Enum.map(fn b -> :erlang.binary_to_term(b) end)
  end
end
