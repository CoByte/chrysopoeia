defmodule Chrysopoeia.Multi do
  @moduledoc """
  Combinators for repeatedly applying parsers
  """

  @doc """
  A combinator.
  Applies `parser` on the input as many times as it can.

  Must match at least `opts`[count] times (defaults to zero).
  """
  def many(parser, opts \\ [count: 0]) do
    &many_parser(parser, opts[:count], &1, [])
  end

  defp many_parser(parser, count, str, out) do
    alias Chrysopoeia.Helper, as: Helper

    case parser.(str) do
      {:ok, data, str} ->
        many_parser(parser, Helper.countdown(count), str, [data | out])

      {:err, _} when count <= 0 ->
        {:ok, out, str}

      _ ->
        {:err, "Could not parse enough inputs"}
    end
  end

  @doc """
  A combinator.
  Applies `parser` on the input until `until` matches.

  Unlike `Multi.many`, if `parser` fails before until is found, the parser
  errors out.
  """
  def many_until(parser, until) do
    &many_until_parser(parser, until, &1, [])
  end

  defp many_until_parser(parser, until, str, out) do
    case until.(str) do
      {:ok, _, _} ->
        {:ok, out, str}

      {:err, _} ->
        case parser.(str) do
          {:ok, data, str} ->
            many_until_parser(parser, until, str, [data | out])

          {:err, _} ->
            {:err, "`until` not found before `parser` finished."}
        end
    end
  end
end
