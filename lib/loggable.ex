defmodule Loggable do
  @moduledoc """
  Protocol for custom views of data in logs (hide sensitive data etc)
  """

  @doc """
  Recursively applies Loggable protocol to term
  """
  def show(x0) do
    x0
    |> Loggable.Protocol.show()
    |> case do
      %{} = x1 ->
        x1
        |> Map.to_list()
        |> Enum.reduce(%{}, fn {k, v}, %{} = acc ->
          Map.put(acc, show(k), show(v))
        end)

      x1 when is_list(x1) ->
        x1
        |> Enum.map(&show/1)

      x1 when is_tuple(x1) ->
        x1
        |> :erlang.tuple_to_list()
        |> Enum.map(&show/1)
        |> :erlang.list_to_tuple()

      x1 ->
        x1
    end
  end
end
