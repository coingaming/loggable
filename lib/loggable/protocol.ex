defprotocol Loggable.Protocol do
  @fallback_to_any true
  @spec show(term) :: term
  def show(x)
end

defimpl Loggable.Protocol, for: Any do
  def show(x), do: x
end
