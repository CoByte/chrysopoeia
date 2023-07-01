defmodule Chrysopoeia.Sequence do
  @moduledoc """
  Combinators for applying parsers in sequence.
  """

  @doc """
  A combinator. Takes a list of parsers, uses each parser in the
  list sequentially, and returns a list of their outputs.

  By wrapping a parser in `{:ig, parser}`, its output will not be included in
  the final output.
  """
  def list(parsers) do
    &list_parser(&1, parsers)
  end

  defp list_parser(str, []) do
    {:ok, [], str}
  end

  defp list_parser(str, [{:ig, parser} | parsers]) do
    with {:ok, _, str} <- parser.(str),
         {:ok, out, str} <- list_parser(str, parsers) do
      {:ok, out, str}
    end
  end

  defp list_parser(str, [parser | parsers]) do
    with {:ok, data, str} <- parser.(str),
         {:ok, out, str} <- list_parser(str, parsers) do
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
