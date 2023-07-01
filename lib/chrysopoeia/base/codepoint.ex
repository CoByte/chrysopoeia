defmodule Chrysopoeia.Base.Codepoint do
  @moduledoc """

  """

  # First extracts the first codepoint from `str`, then if it exists applies
  # `fun`, and returns the output. If a codepoint cannot be extracted (e.g. the
  # string is not valid utf8, or is empty), returns false.
  defp check_first_codepoint(str, fun) do
    case str do
      <<cp::utf8, _::binary>> ->
        fun.(cp)

      _ ->
        false
    end
  end

  # alphabetical codepoints
  @alpha_cps Stream.concat([
               ?A..?Z,
               ?a..?z
             ])
             |> MapSet.new()

  @doc """
  Checks if the first codepoint of `str` is alphabetical.
  """
  def is_alpha?(cp) do
    MapSet.member?(@alpha_cps, cp)
  end

  # whitespace codepoints
  @whitespace_cps Stream.concat([
                    9..13,
                    [32, 133, 160, 5760],
                    8192..8202,
                    8232..8233,
                    [8239, 8287, 12288]
                  ])
                  |> MapSet.new()

  @doc """
  Checks if `cp` is a whitespace codepoint
  """
  def is_whitespace?(cp) do
    MapSet.member?(@whitespace_cps, cp)
  end

  # digit codepoints
  @digit_cps MapSet.new(?0..?9)

  @doc """
  Checks if the first codepoint of `str` is a digit (0-9).
  """
  def is_digit?(cp) do
    MapSet.member?(@digit_cps, cp)
  end

  # digit and alphabetical codepoints
  @alphanum_cps MapSet.union(@alpha_cps, @digit_cps)

  @doc """
  Checks if the first codepoint of `str` is either alphabetical or a digit.
  """
  def is_alphanum?(cp) do
    MapSet.member?(@alphanum_cps, cp)
  end

  @doc """
  Consumes the first codepoint of `str`, if possible.
  """
  def first(str) do
    case str do
      <<cp::utf8, rest::binary>> ->
        {:ok, cp, rest}

      _ ->
        {:err, "Could not take a single codepoint from string"}
    end
  end

  @doc """
  A combinator that consumes a single codepoint, if `fun`.(codepoint) is true.
  """
  def first_if(fun) do
    fn str ->
      with {:ok, cp, rest} <- first(str) do
        if fun.(cp) do
          {:ok, cp, rest}
        else
          {:err, "`fun` did not match #{<<cp>>}"}
        end
      end
    end
  end

  @doc """
  Takes the first `n` codepoints from `str`, if possible.

  Returns a list of codepoints.
  """
  def take(n) do
    &take_p(&1, n, n)
  end

  defp take_p(str, 0, _total) do
    {:ok, [], str}
  end

  defp take_p(str, n, total) do
    with <<cp::utf8, rest::binary>> <- str,
         {:ok, out, str} <- take_p(rest, n - 1, total) do
      {:ok, [cp | out], str}
    else
      _ -> {:err, "Could not take #{total} codepoints from string"}
    end
  end

  @doc """
  A combinator that consumes codepoints while `fun`.(codepoint) is true.
  """
  def take_while(fun) do
    &take_while_p(&1, fun)
  end

  defp take_while_p(str, fun) do
    with <<cp::utf8, rest::binary>> <- str,
         true <- fun.(cp),
         {:ok, out, rest} <- take_while_p(rest, fun) do
      {:ok, [cp | out], rest}
    else
      _ -> {:ok, [], str}
    end
  end
end
