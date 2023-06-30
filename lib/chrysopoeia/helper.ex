defmodule Chrysopoeia.Helper do
  @moduledoc """
  Some helper functions for internal use. These functions are not covered under
  SEMVAR, and should not be used externally. As far as I'm aware, there's no
  such thing as "package-private", so this is what I'm using instead.
  """

  @doc """
  Function that counts down to zero.
  """
  def countdown(n) when n <= 0, do: 0
  def countdown(n), do: n - 1

  @doc """
  Creates a MapSet of characters from a list of list of codepoints.

  Takes a list of lists to allow for ranges to be passed.
  """
  def create_charset(codepoints) do
    codepoints
    |> Stream.concat()
    |> Stream.map(&<<&1>>)
    |> MapSet.new()
  end
end
