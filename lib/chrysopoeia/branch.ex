defmodule Chrysopoeia.Branch do
  @moduledoc """
  Combinators that can parse multiple options.
  """

  @doc """
  Applies a list of `parsers`, returning the result of the first successful
  one.
  """
  def alt(parsers) do
    &alt_parser(parsers, &1)
  end

  defp alt_parser([], _) do
    {:err, "No parsers matched"}
  end

  defp alt_parser([parser | rest], str) do
    case parser.(str) do
      {:err, _} -> alt_parser(rest, str)
      success -> success
    end
  end
end
