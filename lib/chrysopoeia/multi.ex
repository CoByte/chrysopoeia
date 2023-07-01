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
    &many_p(&1, parser, opts[:count], [])
  end

  @doc """
  Function that counts down to zero.
  """
  def countdown(n) when n <= 0, do: 0
  def countdown(n), do: n - 1

  defp many_p(str, parser, count, out) do
    case parser.(str) do
      {:ok, data, str} ->
        many_p(str, parser, countdown(count), [data | out])

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
    &many_until_p(&1, parser, until)
  end

  defp many_until_p(str, parser, until) do
    with {:err, _} <- until.(str),
         {:ok, data, str} <- parser.(str),
         {:ok, out, str} <- many_until_p(str, parser, until) do
      {:ok, [data | out], str}
    else
      # parser failed
      {:err, _} ->
        {:err, "`until` not found before `parser` failed"}

      # until matched
      {:ok, _, _} ->
        {:ok, [], str}
    end
  end
end
