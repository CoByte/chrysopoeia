defmodule Chrysopoeia.Multi do
  @moduledoc """
  Combinators for repeatedly applying parsers.
  """

  alias Chrysopoeia, as: Chr

  @doc """
  A combinator.
  Applies `parser` on the input as many times as it can.

  Must match at least `opts`[count] times (defaults to zero).
  """
  @spec many(Chr.parser(i, o, e), count: non_neg_integer()) :: Chr.parser(i, [o], e)
        when i: var, o: var, e: var
  def many(parser, opts \\ [count: 0]) do
    &many_(&1, parser, opts[:count])
  end

  # Function that counts down to zero.
  defp countdown(n) when n <= 0, do: 0
  defp countdown(n), do: n - 1

  defp many_(str, parser, count) do
    case parser.(str) do
      {:ok, data, str} ->
        with {:ok, out, str} <- many_(str, parser, countdown(count)) do
          {:ok, [data | out], str}
        end

      {:err, _} when count <= 0 ->
        {:ok, [], str}

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
  @spec many_until(Chr.parser(i, o, e1), Chr.parser(i, any(), any())) ::
          Chr.parser(i, [o], e1 | any())
        when i: var, o: var, e1: var
  def many_until(parser, until) do
    &many_until_(&1, parser, until)
  end

  defp many_until_(str, parser, until) do
    with {:err, _} <- until.(str),
         {:ok, data, str} <- parser.(str),
         {:ok, out, str} <- many_until_(str, parser, until) do
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
