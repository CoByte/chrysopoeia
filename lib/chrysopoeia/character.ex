defmodule Chrysopoeia.Character do
  @moduledoc """
  Combinators for consuming characters.
  """

  # whitespace codepoints
  @whitespace_cps Chrysopoeia.Helper.create_charset([
                    9..13,
                    [32, 133, 160, 5760],
                    8192..8202,
                    8232..8233,
                    [8239, 8287, 12288]
                  ])

  # alphabetical codepoints
  @alpha_cps Stream.concat([
               ?A..?Z,
               ?a..?z
             ])
             |> Stream.map(&<<&1>>)
             |> MapSet.new()

  # digit codepoints
  @digit_cps MapSet.new(?0..?9)

  # digit and alphabetical codepoints
  @alphanum_cps MapSet.union(@alpha_cps, @digit_cps)

  @doc """
  A combinator that consumes `prefix` from the start of `input` if it matches.
  """
  def tag(prefix) do
    fn input ->
      if String.starts_with?(input, prefix) do
        # algorithm taken from
        # [[https://hexdocs.pm/elixir/1.12/String.html#module-string-and-binary-operations]]
        base = byte_size(prefix)
        rem = binary_part(input, base, byte_size(input) - base)
        {:ok, prefix, rem}
      else
        {:err, "Parse Error: \"#{prefix}\" does not match the beginning of \"#{input}\""}
      end
    end
  end

  @doc """
  A parser that consumes a single character if it is whitespace. Characters are
  considered whitespace if their unicode property White_Space=yes.

  See [[https://codedocs.org/what-is/whitespace-character]] for details.
  """
  def whitespace(str) do
    case str do
      <<codepoint::utf8, rest::binary>> ->
        if MapSet.member?(@whitespace_cps, <<codepoint>>) do
          {:ok, <<codepoint>>, rest}
        else
          {:err, "First character is not whitespace"}
        end

      _ ->
        {:err, "String cannot be parsed into utf8"}
    end
  end

  @doc """
  A combinator that consumes codepoints while `fun`.(codepoint) is true.
  """
  def take_while(fun) do
    fn str ->
      {a, b} =
        String.codepoints(str)
        |> Enum.split_while(fun)

      {:ok, List.to_string(a), List.to_string(b)}
    end
  end

  @doc """
  Checks if the first codepoint of `str` is alphabetical.
  """
  def is_alpha?(str) do
    MapSet.member?(@alpha_cps, str)
  end

  @doc """
  Consumes as many alphabetical characters as possible.
  """
  def alpha(str) do
    take_while(&is_alpha?/1).(str)
  end
end
