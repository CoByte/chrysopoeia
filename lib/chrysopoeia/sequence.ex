defmodule Chrysopoeia.Sequence do
  @moduledoc """
  Combinators for applying parsers in sequence.
  """

  @doc """
  A combinator. Takes a list of parsers, uses each parser in the
  list sequentially, and returns a list of their outputs.
  """
  def list(parsers) do
    &list_parser(parsers, &1)
  end

  defp list_parser([], str) do
    {:ok, [], str}
  end

  defp list_parser([parser | parsers], str) do
    with {:ok, data, str} <- parser.(str),
         {:ok, out, str} <- list_parser(parsers, str) do
      {:ok, [data | out], str}
    end
  end

  @doc """
  A combinator. First applies the `prefix` parser, then applies `parser`, and
  returns the result of `parser`.
  """
  def prefix(prefix, parser) do
    fn str ->
      with {:ok, _, str} <- prefix.(str) do
        parser.(str)
      end
    end
  end

  @doc """
  A combinator. First applies `parser`, then the `suffix` parser, and returns
  the result of `parser`.
  """
  def suffix(parser, suffix) do
    fn str ->
      with {:ok, out, str} <- parser.(str),
           {:ok, _, str} <- suffix.(str) do
        {:ok, out, str}
      end
    end
  end
end
