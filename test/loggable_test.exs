defmodule LoggableTest do
  use ExUnit.Case
  doctest Loggable

  defmodule Wrapper do
    @enforce_keys [:user]
    defstruct @enforce_keys
  end

  defmodule User do
    @enforce_keys [:name, :balance, :card]
    defstruct @enforce_keys
  end

  defimpl Loggable.Protocol, for: User do
    def show(%User{} = x) do
      %User{x | card: "[SECRET]"}
    end
  end

  setup _ do
    x0 = %User{
      name: "Jessy",
      balance: 100,
      card: "4510 6459 8301 6543"
    }

    x1 = %User{
      name: "Bob",
      balance: 500,
      card: "4510 6459 8301 6999"
    }

    {:ok, %{x0: x0, x1: x1}}
  end

  test "user", %{x0: x0} do
    assert %User{
             name: "Jessy",
             balance: 100,
             card: "[SECRET]"
           } == Loggable.show(x0)
  end

  test "list of users", %{x0: x0, x1: x1} do
    assert [
             %User{
               name: "Jessy",
               balance: 100,
               card: "[SECRET]"
             },
             %User{
               name: "Bob",
               balance: 500,
               card: "[SECRET]"
             }
           ] == Loggable.show([x0, x1])
  end

  test "tuple of users", %{x0: x0, x1: x1} do
    assert {
             %User{
               name: "Jessy",
               balance: 100,
               card: "[SECRET]"
             },
             %User{
               name: "Bob",
               balance: 500,
               card: "[SECRET]"
             }
           } == Loggable.show({x0, x1})
  end

  test "nested structs", %{x0: x0} do
    assert %Wrapper{
             user: %User{
               name: "Jessy",
               balance: 100,
               card: "[SECRET]"
             }
           } ==
             %Wrapper{user: x0}
             |> Loggable.show()
  end
end
