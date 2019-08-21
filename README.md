# Loggable

Sometimes it's needed to hide some chunks of data before applying Logger functions. For example credit card numbers, passwords and other sensitive information. Loggable protocol helps us to do it for any type of data. It has fallback to `Any` (does not do anything by default).

<img src="priv/img/logo.jpg" width="300"/>

## Usage

```elixir
defmodule User do
  @enforce_keys [:name, :balance, :card]
  defstruct @enforce_keys
end

defimpl Loggable.Protocol, for: User do
  def show(%User{} = x) do
    %User{x | card: "[SECRET]"}
  end
end
```

and then

```elixir
iex> x = %User{
...>   name: "Jessy",
...>   balance: 100,
...>   card: "4510 6459 8301 6543"
...> }
%User{balance: 100, card: "4510 6459 8301 6543", name: "Jessy"}

iex> Loggable.show(x)
%User{balance: 100, card: "[SECRET]", name: "Jessy"}

iex> Loggable.show(%{foo: [x, x, x]})
%{
  foo: [
    %User{balance: 100, card: "[SECRET]", name: "Jessy"},
    %User{balance: 100, card: "[SECRET]", name: "Jessy"},
    %User{balance: 100, card: "[SECRET]", name: "Jessy"}
  ]
}
```

## Installation

The package can be installed by adding `loggable` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:loggable, "~> 0.1.0"}
  ]
end
```
