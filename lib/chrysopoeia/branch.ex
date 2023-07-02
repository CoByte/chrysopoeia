defmodule Chrysopoeia.Branch do
  @moduledoc """
  Combinators that can parse multiple options.
  """

  alias Chrysopoeia, as: Chr

  @doc """
  Applies a list of `parsers`, returning the result of the first successful
  one.
  """
  @spec alt([Chr.parser(any(), input, any())]) :: Chr.parser(any(), input, any())
        when input: var
  def alt(parsers) do
    &alt_(&1, parsers)
  end

  defp alt_(_str, []) do
    {:err, "No parsers matched"}
  end

  defp alt_(str, [parser | rest]) do
    with {:err, _} <- parser.(str) do
      alt_(str, rest)
    end
  end
end
