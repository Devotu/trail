defmodule Trail.Helpers do
  def enforce_tuple(t) when is_tuple(t), do: t
  def enforce_tuple(t), do: {t}
end
