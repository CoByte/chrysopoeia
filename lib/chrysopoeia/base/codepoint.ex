defmodule Chrysopoeia.Base.Codepoint do
  @moduledoc """
  Base module for parsing codepoints.
  """

  alias Chrysopoeia, as: Chr

  # alphabetical codepoints
  @alpha_cps Stream.concat([
               ?A..?Z,
               ?a..?z
             ])
             |> MapSet.new()

  @doc """
  Checks if the first codepoint of `str` is alphabetical.
  """
  @spec is_alpha?(char()) :: boolean()
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
  @spec is_whitespace?(char()) :: boolean()
  def is_whitespace?(cp) do
    MapSet.member?(@whitespace_cps, cp)
  end

  # digit codepoints
  @digit_cps MapSet.new(?0..?9)

  @doc """
  Checks if the first codepoint of `str` is a digit (0-9).
  """
  @spec is_digit?(char()) :: boolean()
  def is_digit?(cp) do
    MapSet.member?(@digit_cps, cp)
  end

  # digit and alphabetical codepoints
  @alphanum_cps MapSet.union(@alpha_cps, @digit_cps)

  @doc """
  Checks if the first codepoint of `str` is either alphabetical or a digit.
  """
  @spec is_alphanum?(char()) :: boolean()
  def is_alphanum?(cp) do
    MapSet.member?(@alphanum_cps, cp)
  end

  @doc """
  Consumes the first codepoint of `str`, if possible.
  """
  @spec first(i) :: {:ok, char(), i} | {:err, any()}
        when i: String.t()
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
  @spec first_if((char() -> boolean())) ::
          Chr.parser(String.t(), char(), any())
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
  @spec take(char()) :: Chr.parser(String.t(), charlist(), any())
  def take(n) do
    &take_(&1, n, n)
  end

  defp take_(str, 0, _total) do
    {:ok, [], str}
  end

  defp take_(str, n, total) do
    with <<cp::utf8, rest::binary>> <- str,
         {:ok, out, str} <- take_(rest, n - 1, total) do
      {:ok, [cp | out], str}
    else
      _ -> {:err, "Could not take #{total} codepoints from string"}
    end
  end

  @doc """
  A combinator that consumes codepoints while `fun`.(codepoint) is true.
  """
  @spec take_while((char() -> boolean())) ::
          Chr.parser(String.t(), charlist(), any())
  def take_while(fun) do
    &take_while_(&1, fun)
  end

  defp take_while_(str, fun) do
    with <<cp::utf8, rest::binary>> <- str,
         true <- fun.(cp),
         {:ok, out, rest} <- take_while_(rest, fun) do
      {:ok, [cp | out], rest}
    else
      _ -> {:ok, [], str}
    end
  end
end
